-- Cây widget toàn app (runtime) lấy từ Flutter inspector qua phiên nvim-dap, hiển thị trong buffer riêng
local M = {}

local scope = require("config.flutter.scope")

local BUF_NAME = "__FLUTTER_WIDGET_TREE__"
local GROUP = "config-flutter-tree"
local NS = vim.api.nvim_create_namespace("flutter_widget_tree")
local MIN_WIDTH, MIN_MAX_WIDTH, MAX_WIDTH_RATIO = 36, 70, 0.55
local SEGMENT_WIDTH, NAME_RESERVE, MIN_LEVELS = 3, 28, 6
local PUSH_THROTTLE_MS, SELF_EVENT_NS = 120, 600 * 1000 * 1000

-- Trạng thái duy nhất: cây gốc, các dòng đang hiển thị và tập nút đã thu gọn (theo valueId)
local S = { root = nil, lines = {}, collapsed = {}, custom = {}, group = GROUP, seq = 0, isolate = nil, sel = nil, pushed_at = 0, last_row = nil, synced = nil, last_run = 0, view = nil, view_offset = 0, zoom_stack = {}, raw = nil, visible = nil }

-- Nhóm widget theo vai trò; widget không nằm trong bảng nào dùng màu Normal
local KINDS = {
  Layout = {
    "Row", "Column", "Stack", "Padding", "Center", "Align", "Expanded", "Flexible", "SizedBox", "Wrap", "Flex",
    "ListView", "GridView", "Positioned", "ConstrainedBox", "SingleChildScrollView", "Container", "Spacer",
  },
  Structure = {
    "MaterialApp", "CupertinoApp", "Scaffold", "AppBar", "Card", "Drawer", "BottomNavigationBar", "TabBar",
    "SafeArea", "Material", "Theme", "Navigator", "Builder", "Hero",
  },
  Content = { "Text", "Icon", "Image", "RichText", "CircleAvatar", "Divider", "ListTile", "Chip" },
  Action = {
    "TextButton", "ElevatedButton", "OutlinedButton", "IconButton", "FloatingActionButton", "InkWell",
    "GestureDetector", "TextField", "TextFormField", "Checkbox", "Switch", "Slider", "DropdownButton",
  },
}
local KIND_OF = {}
for kind, names in pairs(KINDS) do
  for _, name in ipairs(names) do
    KIND_OF[name] = kind
  end
end

local HL_LINKS = {
  FlutterTreeGuide = "NonText",
  FlutterTreeRoot = "Title",
  FlutterTreeSel = "Visual",
  FlutterTreeAlt = "ColorColumn",
  FlutterTreeNormal = "Normal",
  FlutterTreeLayout = "Function",
  FlutterTreeStructure = "Statement",
  FlutterTreeContent = "String",
  FlutterTreeAction = "@variable.builtin",
}
-- Đặt màu theo theme hiện tại; gọi lại mỗi khi đổi colorscheme
local function apply_highlights()
  for group, link in pairs(HL_LINKS) do
    vim.api.nvim_set_hl(0, group, { default = true, link = link })
  end
  -- Widget do chính project định nghĩa: nổi bật nhất (đậm, màu cảnh báo của theme)
  local warn = vim.api.nvim_get_hl(0, { name = "DiagnosticWarn", link = false })
  vim.api.nvim_set_hl(0, "FlutterTreeCustom", { fg = warn.fg, bold = true })
end
apply_highlights()
vim.api.nvim_create_autocmd("ColorScheme", { group = vim.api.nvim_create_augroup("flutter_tree_hl", {}), callback = apply_highlights })

local function notify(msg, level) vim.notify("Flutter widget tree: " .. msg, level or vim.log.levels.WARN) end

local function find_buf()
  local buf = vim.fn.bufnr(BUF_NAME)
  if buf ~= -1 then return buf end
end

local function count_descendants(node)
  local total = 0
  for _, child in ipairs(node.children or {}) do
    total = total + 1 + count_descendants(child)
  end
  return total
end

-- Duỗi cây thành danh sách dòng; guide là phần nhánh ├─ └─ │ đứng trước tên widget
local function flatten(node, guide, child_guide, out)
  out[#out + 1] = { node = node, guide = guide }
  if S.collapsed[node.valueId] then return end
  local children = node.children or {}
  for i, child in ipairs(children) do
    local last = i == #children
    flatten(child, child_guide .. (last and "└─ " or "├─ "), child_guide .. (last and "   " or "│  "), out)
  end
end

local function max_width() return math.max(MIN_MAX_WIDTH, math.floor(vim.o.columns * MAX_WIDTH_RATIO)) end

-- Tính độ sâu từng dòng và số cấp đầu bị nén (mỗi cấp nén chỉ còn 1 cột thay vì 3) để cây sâu vẫn vừa cửa sổ
-- mà con luôn nằm bên phải cha; luôn giữ nguyên MIN_LEVELS cấp sâu nhất ở đủ 3 cột
local function plan_levels(lines)
  local max_depth = 0
  for _, entry in ipairs(lines) do
    entry.depth = vim.fn.strchars(entry.guide) / SEGMENT_WIDTH
    max_depth = math.max(max_depth, entry.depth)
  end
  local avail = max_width() - (#tostring(max_depth + S.view_offset) + 3) - NAME_RESERVE
  local base = math.ceil((SEGMENT_WIDTH * max_depth - avail) / (SEGMENT_WIDTH - 1))
  return math.max(0, math.min(base, max_depth - MIN_LEVELS)), max_depth
end

-- Nhánh nén: chỉ giữ ký tự đầu (│ ├ └ hoặc khoảng trắng) của `count` đoạn nhánh đầu, mỗi cấp 1 cột nhưng vẫn nối cha-con
local function squeeze(guide, count)
  local parts = {}
  for i = 0, count - 1 do
    parts[#parts + 1] = vim.fn.strcharpart(guide, SEGMENT_WIDTH * i, 1)
  end
  return table.concat(parts)
end

-- Phần đứng trước tên: khi có cấp bị nén hoặc đang thu phóng thì có cột độ sâu thật ‹N›; cấp nén vẽ nhánh 1 cột mỗi cấp,
-- các cấp còn lại vẽ nhánh đầy đủ
local function shown_guide(entry, base, width)
  if base == 0 and S.view_offset == 0 then return entry.guide end
  local gutter = string.format("‹%" .. width .. "d› ", entry.depth + S.view_offset)
  return gutter .. squeeze(entry.guide, math.min(entry.depth, base)) .. vim.fn.strcharpart(entry.guide, SEGMENT_WIDTH * base)
end

-- Loại màu của widget: custom (class trong project) > nhóm vai trò > Normal
local function name_group(node, row)
  if row == 0 then return "FlutterTreeRoot" end
  if S.custom[node.description] then return "FlutterTreeCustom" end
  return "FlutterTree" .. (KIND_OF[node.description] or "Normal")
end

-- Gắn màu cho nhánh, tên, số nút con bị thu gọn và nền xen kẽ của một dòng
local function decorate(buf, row, entry)
  local node = entry.node
  local name_start = #entry.shown
  vim.api.nvim_buf_set_extmark(buf, NS, row, 0, { end_col = name_start, hl_group = "FlutterTreeGuide" })
  vim.api.nvim_buf_set_extmark(buf, NS, row, name_start, { end_col = name_start + #node.description, hl_group = name_group(node, row) })
  if row % 2 == 1 then vim.api.nvim_buf_set_extmark(buf, NS, row, 0, { line_hl_group = "FlutterTreeAlt", priority = 50 }) end
  local virt = {}
  if S.collapsed[node.valueId] then virt[#virt + 1] = { " ▸ +" .. count_descendants(node), "FlutterTreeGuide" } end
  if #virt > 0 then vim.api.nvim_buf_set_extmark(buf, NS, row, 0, { virt_text = virt, virt_text_pos = "eol" }) end
end

local function fit_width(win, lines)
  local widest = 0
  for _, line in ipairs(lines) do
    widest = math.max(widest, vim.fn.strdisplaywidth(line))
  end
  vim.api.nvim_win_set_width(win, math.min(max_width(), math.max(MIN_WIDTH, widest + 24)))
end

-- Cửa sổ mã nguồn thường (không phải scratch hay float), ưu tiên tab hiện tại rồi tới các tab khác
local function find_code_win()
  local tabs = vim.api.nvim_list_tabpages()
  table.sort(tabs, function(a, b) return a == vim.api.nvim_get_current_tabpage() and b ~= a end)
  for _, tab in ipairs(tabs) do
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.bo[buf].buftype == "" and vim.api.nvim_win_get_config(win).relative == "" then return win end
    end
  end
end

-- Vị trí tạo widget; widget tóm tắt không có vị trí riêng thì lấy của con đầu tiên (giống plugin)
local function location_of(node)
  local loc = node.creationLocation or (node.children and node.children[1] and node.children[1].creationLocation)
  return loc and loc.file and loc or nil
end

-- Swap file đang tồn tại của file (theo quy ước đặt tên của 'directory'), nil khi chưa có
local function find_swapfile(file)
  for _, dir in ipairs(vim.opt.directory:get()) do
    local pattern
    if dir:sub(-2) == "//" then
      pattern = dir:sub(1, -2) .. (file:gsub("/", "%%")) .. ".sw?"
    elseif dir == "." then
      pattern = vim.fs.dirname(file) .. "/." .. vim.fs.basename(file) .. ".sw?"
    else
      pattern = dir .. "/" .. vim.fs.basename(file) .. ".sw?"
    end
    local found = vim.fn.glob(vim.fn.expand(pattern), true, true)
    if #found > 0 then return found[1] end
  end
end

-- Mở file. Đã có swap file (nvim khác đang giữ hoặc mồ côi) thì mở bằng :noswapfile để không phát sinh SwapExists: handler
-- SwapExists của noice.nvim redraw giữa lúc nvim đang mở buffer và làm nvim 0.12.4 segfault trong compose_line.
-- Chủ swap còn sống thì đặt chỉ đọc để không sửa chồng lên phiên kia
local function edit_file(file)
  local swap = find_swapfile(file)
  local ok, err = pcall(vim.cmd, (swap and "noswapfile " or "") .. "edit " .. vim.fn.fnameescape(file))
  if not ok then return notify("không mở được " .. file .. ": " .. tostring(err)) end
  local pid = swap and vim.fn.swapinfo(swap).pid
  if pid and pid > 0 and vim.uv.kill(pid, 0) == 0 then vim.bo.readonly = true end
end

-- Đưa cửa sổ hiện tại tới vị trí tạo widget. Phải chạy ngoài autocmd (autocmd mặc định không lồng nhau, :edit trong
-- handler CursorMoved sẽ không kích hoạt FileType/BufReadPost nên buffer không có LSP, treesitter, SwapExists)
local function open_location(loc)
  local file = (loc.file:gsub("^file://", ""))
  local line, col = loc.line or 1, (loc.column or 1) - 1
  if vim.api.nvim_buf_get_name(0) == file and vim.api.nvim_win_get_cursor(0)[1] == line then return end
  if vim.api.nvim_buf_get_name(0) ~= file then edit_file(file) end
  vim.api.nvim_win_set_cursor(0, { line, col })
  vim.cmd("normal! zz")
end

-- Hiện mã nguồn ở cửa sổ code mà không đổi focus (dùng khi đồng bộ từ app, chạy từ vim.schedule)
local function show_code(loc)
  local win = find_code_win()
  if loc and win then vim.api.nvim_win_call(win, function() open_location(loc) end) end
end

-- Chọn widget này trên app (app tô khung widget); ghi lại thời điểm để bỏ qua sự kiện Inspect do chính việc này gây ra
local function push_selection(node)
  local session = require("dap").session()
  if not session or not S.isolate or not node.valueId then return end
  S.pushed_at = vim.uv.hrtime()
  local params = { arg = node.valueId, objectGroup = S.group, isolateId = S.isolate }
  session:request("callService", { method = "ext.flutter.inspector.setSelectionById", params = params }, function() end)
end

-- Enter: nhảy tới mã nguồn của widget (focus sang cửa sổ code, mở file như bình thường nên LSP, treesitter gắn đủ) và tô khung widget trên app
local function jump()
  local entry = S.lines[vim.api.nvim_win_get_cursor(0)[1]]
  local loc = entry and location_of(entry.node)
  if not loc then return notify("widget này không có vị trí mã nguồn") end
  push_selection(entry.node)
  S.synced = entry.node
  local win = find_code_win()
  if win then vim.api.nvim_set_current_win(win) end
  open_location(loc)
end

local function toggle_collapse()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local node = S.lines[row] and S.lines[row].node
  if not node or #(node.children or {}) == 0 then return end
  S.collapsed[node.valueId] = not S.collapsed[node.valueId] or nil
  M.draw()
  vim.api.nvim_win_set_cursor(0, { row, 0 })
end

-- Thu phóng vào nút dưới con trỏ: nút đó thành gốc hiển thị, thụt lề tính tương đối từ nó
local function zoom_in()
  local entry = S.lines[vim.api.nvim_win_get_cursor(0)[1]]
  if not entry or entry.node == (S.view or S.root) then return end
  if #(entry.node.children or {}) == 0 then return notify("nút lá, không có nhánh để thu phóng", vim.log.levels.INFO) end
  S.zoom_stack[#S.zoom_stack + 1] = { view = S.view, offset = S.view_offset, node = entry.node }
  S.view, S.view_offset = entry.node, S.view_offset + entry.depth
  M.draw()
  vim.api.nvim_win_set_cursor(0, { 1, 0 })
end

-- Thu phóng ra một bước và đặt con trỏ về nút vừa thu phóng vào
local function zoom_out()
  local prev = table.remove(S.zoom_stack)
  if not prev then return notify("đang ở gốc cây", vim.log.levels.INFO) end
  S.view, S.view_offset = prev.view, prev.offset
  M.draw()
  for row, entry in ipairs(S.lines) do
    if entry.node == prev.node then return vim.api.nvim_win_set_cursor(0, { row, 0 }) end
  end
end

-- Lấy buffer cây, tạo mới (scratch, chỉ đọc) khi chưa có
local function get_buf()
  local buf = find_buf()
  if buf then return buf end
  buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_name(buf, BUF_NAME)
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "hide"
  vim.bo[buf].modifiable = false
  vim.bo[buf].filetype = "flutter_widget_tree"
  local map = function(lhs, rhs, desc) vim.keymap.set("n", lhs, rhs, { buffer = buf, nowait = true, desc = desc }) end
  map("<CR>", jump, "Mở mã nguồn widget")
  map("<Tab>", toggle_collapse, "Thu gọn/mở nút")
  map("r", function() M.open() end, "Tải lại cây widget")
  map("i", function() require("config.flutter.inspect").toggle() end, "Bật/Tắt Inspect Widget")
  map("z", zoom_in, "Thu phóng vào nút")
  map("Z", zoom_out, "Thu phóng ra")
  map("s", function() M.switch() end, "Đổi isolate giao diện")
  map("q", "<cmd>close<cr>", "Đóng cây widget")
  return buf
end

local function open_win(buf)
  vim.cmd("botright vertical " .. MIN_WIDTH .. "split")
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(win, buf)
  for opt, value in pairs({
    number = false,
    relativenumber = false,
    signcolumn = "no",
    wrap = false,
    cursorline = true,
    list = false,
    foldcolumn = "0",
    winfixwidth = true,
    winbar = "%#FlutterTreeCustom# ■ custom %#FlutterTreeLayout#■ layout %#FlutterTreeStructure#■ structure "
      .. "%#FlutterTreeContent#■ content %#FlutterTreeAction#■ action",
  }) do
    vim.wo[win][opt] = value
  end
  return win
end

function M.draw()
  local buf = get_buf()
  S.lines = {}
  flatten(S.view or S.root, "", "", S.lines)
  local base, max_depth = plan_levels(S.lines)
  local width = #tostring(max_depth + S.view_offset)
  local texts = {}
  for _, entry in ipairs(S.lines) do
    entry.shown = shown_guide(entry, base, width)
    texts[#texts + 1] = entry.shown .. entry.node.description
  end
  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, texts)
  vim.bo[buf].modifiable = false
  vim.api.nvim_buf_clear_namespace(buf, NS, 0, -1)
  for row, entry in ipairs(S.lines) do
    decorate(buf, row - 1, entry)
  end
  local win = vim.fn.win_findbuf(buf)[1] or open_win(buf)
  S.last_row = S.last_row or vim.api.nvim_win_get_cursor(win)[1]
  fit_width(win, texts)
end

-- Quét tên class widget của project bằng rg chạy nền (không chặn nvim); lỗi hoặc thiếu rg thì trả tập rỗng
local function project_widgets(callback)
  local pattern = "^class\\s+([A-Za-z0-9_]+)\\s+extends\\s+[A-Za-z0-9_]*Widget"
  local ok = pcall(vim.system, { "rg", "-o", "--no-filename", "--no-line-number", "-r", "$1", pattern, "lib" }, { text = true, cwd = vim.fn.getcwd() }, function(result)
    local names = {}
    for name in (result.stdout or ""):gmatch("[^\n]+") do
      names[name] = true
    end
    vim.schedule(function() callback(names) end)
  end)
  if not ok then callback({}) end
end

-- Lấy cây bằng nhóm đối tượng mới rồi mới giải phóng nhóm cũ, nên không phải chờ thêm một vòng gọi trước khi lấy cây
local function fetch_tree(session, callback)
  S.seq = S.seq + 1
  local group = GROUP .. "-" .. S.seq
  require("config.flutter.isolate").call(session, "ext.flutter.inspector.getRootWidgetSummaryTree", { objectGroup = group }, function(err, response, isolate_id)
    if err or not response then return callback(nil) end
    local previous = S.group
    if S.isolate then
      session:request("callService", { method = "ext.flutter.inspector.disposeGroup", params = { objectGroup = previous, isolateId = S.isolate } }, function() end)
    end
    S.group, S.isolate = group, isolate_id
    callback(response.result or response)
  end)
end

-- Cây và danh sách class widget được lấy song song; vẽ một lần khi cả hai xong
function M.open(on_done)
  local session = require("dap").session()
  if not session then return notify("chưa có app đang chạy qua DAP") end
  local pending, tree, custom = 2, nil, nil
  local function finish()
    pending = pending - 1
    if pending > 0 then return end
    if not tree then return notify("không lấy được cây widget") end
    local shown, visible = scope.user_tree(tree)
    if not shown then
      notify("không thấy widget của project, hiện toàn bộ cây", vim.log.levels.INFO)
      shown, visible = tree, nil
    end
    S.raw, S.root, S.visible, S.custom, S.collapsed = tree, shown, visible, custom, {}
    S.view, S.view_offset, S.zoom_stack = nil, 0, {}
    M.draw()
    if on_done then on_done() end
  end
  project_widgets(function(names)
    custom = names
    finish()
  end)
  fetch_tree(session, function(result)
    tree = result
    vim.schedule(finish)
  end)
end

-- Cây đang hiển thị thì đóng cửa sổ, chưa hiển thị thì mở
function M.toggle()
  local buf = find_buf()
  local win = buf and vim.fn.win_findbuf(buf)[1]
  if win then return vim.api.nvim_win_close(win, true) end
  M.open()
end

-- Chuyển cây sang isolate giao diện kế tiếp và chuyển chế độ inspector theo; chỉ có một isolate thì báo và giữ nguyên
function M.switch()
  local session = require("dap").session()
  if not session then return notify("chưa có app đang chạy qua DAP") end
  require("config.flutter.isolate").cycle(session, function(new_id, index, total, old_id)
    vim.schedule(function()
      if total <= 1 then return notify("app chỉ có một isolate giao diện", vim.log.levels.INFO) end
      require("config.flutter.inspect").move(session, old_id, new_id)
      notify(string.format("isolate %d/%d", index, total), vim.log.levels.INFO)
      M.open()
    end)
  end)
end

-- Đường đi từ gốc tới nút có valueId, gồm cả nút đó
local function path_to(node, value_id, path)
  path[#path + 1] = node
  if node.valueId == value_id then return true end
  for _, child in ipairs(node.children or {}) do
    if path_to(child, value_id, path) then return true end
  end
  path[#path] = nil
  return false
end

-- Đường tới nút trong vùng đang thu phóng; nút nằm ngoài vùng đó thì trở về toàn cây (reset=true)
local function locate(value_id)
  local path = {}
  if S.view and path_to(S.view, value_id, path) then return path, false end
  path = {}
  if not path_to(S.root, value_id, path) then return nil end
  local reset = S.view ~= nil
  S.view, S.view_offset, S.zoom_stack = nil, 0, {}
  return path, reset
end

-- Mở các nút cha đang thu gọn trên đường tới nút được chọn; trả về true nếu có nút phải mở
local function expand_path(path)
  local changed = false
  for _, node in ipairs(path) do
    if S.collapsed[node.valueId] then
      S.collapsed[node.valueId] = nil
      changed = true
    end
  end
  return changed
end

-- Đưa con trỏ tới widget vừa chọn trên máy và tô sáng dòng đó; chỉ vẽ lại cây khi phải mở nút đang thu gọn
local function select_node(value_id)
  local buf = find_buf()
  local win = buf and vim.fn.win_findbuf(buf)[1]
  if not S.root or not win then return false end
  local path, reset = locate(value_id)
  if not path then return false end
  if expand_path(path) or reset then M.draw() end
  if S.sel then pcall(vim.api.nvim_buf_del_extmark, buf, NS, S.sel) end
  for row, entry in ipairs(S.lines) do
    if entry.node.valueId == value_id then
      S.last_row, S.synced = row, entry.node
      vim.api.nvim_win_set_cursor(win, { row, 0 })
      S.sel = vim.api.nvim_buf_set_extmark(buf, NS, row - 1, 0, { line_hl_group = "FlutterTreeSel", priority = 200 })
      return true
    end
  end
  return false
end

local function tree_visible()
  local buf = find_buf()
  return S.root ~= nil and buf ~= nil and #vim.fn.win_findbuf(buf) > 0
end

-- Nút hiển thị ứng với widget được chọn: chính nó, hoặc tổ tiên gần nhất là widget của project khi nó là widget hệ thống (bị ẩn)
local function visible_target(value_id)
  local path = {}
  if not S.raw or not path_to(S.raw, value_id, path) then return nil end
  for i = #path, 1, -1 do
    if not S.visible or S.visible[path[i].valueId] then return path[i] end
  end
end

-- Hỏi inspector widget đang chọn, đưa vào cây trước (rẻ) rồi nhảy code từ chính phản hồi (có thể phải nạp file); cây thuộc isolate khác (hot restart đánh số
-- valueId lại từ đầu) hoặc không có nút đó thì làm mới cây một lần
local function sync_selection(session, isolate_id, retry)
  local params = { previousSelectionId = vim.NIL, objectGroup = S.group, isolateId = isolate_id }
  session:request("callService", { method = "ext.flutter.inspector.getSelectedSummaryWidget", params = params }, function(err, response)
    local widget = not err and response and (response.result or response)
    if not widget or not widget.valueId then return end
    vim.schedule(function()
      local viewed = require("config.flutter.isolate").current()
      local own = isolate_id == S.isolate
      -- Cây của isolate khác (hoặc cây cũ sau hot restart) không dùng được để tìm tổ tiên: chỉ nhảy code khi chính widget là của project
      local target = own and visible_target(widget.valueId) or (scope.is_user(location_of(widget)) and widget) or nil
      if viewed and viewed ~= isolate_id then return target and show_code(location_of(target)) end
      local selected = own and target ~= nil and select_node(target.valueId)
      if target then show_code(location_of(target)) end
      if selected or not retry then return end
      M.open(function() sync_selection(session, isolate_id, false) end)
    end)
  end)
end

-- Khi chọn widget trên máy (sự kiện Inspect): cây đang mở thì tự đồng bộ cả cây lẫn code bằng một lệnh, không thì giao plugin
local function on_inspect(event, plugin_handler)
  vim.schedule(function()
    local session = require("dap").session()
    if session and tree_visible() then return sync_selection(session, event.isolate.id, true) end
    plugin_handler(event)
  end)
end

-- Con trỏ dời sang dòng khác thì chỉ tô khung widget trên app (xem trước); không nhảy code, việc đó chỉ làm khi nhấn Enter.
-- Bỏ qua khi dòng không đổi (focus cửa sổ, vẽ lại cây, đồng bộ từ app không tính)
local function sync_cursor()
  if vim.api.nvim_get_current_buf() ~= find_buf() then return end
  local row = vim.api.nvim_win_get_cursor(0)[1]
  if row == S.last_row then return end
  S.last_row = row
  local entry = S.lines[row]
  if not entry or S.synced == entry.node then return end
  S.synced = entry.node
  push_selection(entry.node)
end

-- Throttle: lần dời đầu sau khi nghỉ chạy ngay; các lần dời liên tiếp gộp lại, giữ phím thì cứ mỗi PUSH_THROTTLE_MS chạy một lần
local push_timer = vim.uv.new_timer()
local function on_tree_cursor()
  if vim.api.nvim_get_current_buf() ~= find_buf() then return end
  push_timer:stop()
  local now = vim.uv.hrtime()
  if now - S.last_run >= PUSH_THROTTLE_MS * 1000 * 1000 then
    S.last_run = now
    return sync_cursor()
  end
  push_timer:start(PUSH_THROTTLE_MS, 0, vim.schedule_wrap(function()
    S.last_run = vim.uv.hrtime()
    sync_cursor()
  end))
end

local function is_self_event() return vim.uv.hrtime() - S.pushed_at < SELF_EVENT_NS end

-- Plugin chỉ cho một handler mỗi stream: bọc stream_listen để sự kiện Inspect đi qua đồng bộ của cây trước, rồi mới tới plugin
function M.setup()
  local vm_service = require("config.flutter.vm_service")
  local original = vm_service.stream_listen
  vim.api.nvim_create_autocmd("CursorMoved", { group = vim.api.nvim_create_augroup("flutter_tree_sync", {}), callback = on_tree_cursor })
  vm_service.stream_listen = function(stream_id, handler, callback)
    if stream_id ~= "Debug" then return original(stream_id, handler, callback) end
    return original(stream_id, function(event)
      if not (event and event.kind == "Inspect" and event.isolate) then return handler(event) end
      -- Sự kiện Inspect do chính setSelectionById gây ra: bỏ qua để không đồng bộ ngược lại
      if is_self_event() then return end
      on_inspect(event, handler)
    end, callback)
  end
end

return M

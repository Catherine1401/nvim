-- Buffer diffview:// không có LSP (server chỉ nhận file://), nên gd/gD/gi/K gửi tới file thật cùng đường dẫn
local M = {}

local HOVER = "textDocument/hover"
local KEYS = {
  gd = { method = "textDocument/definition", desc = "Go to definition (file thật)" },
  gD = { method = "textDocument/declaration", desc = "Go to declaration (file thật)" },
  gi = { method = "textDocument/implementation", desc = "Go to implementation (file thật)" },
  K = { method = HOVER, desc = "Hover Info (file thật)" },
}

-- Đường dẫn file thật từ tên buffer diffview://<root>/.git/<rev>:/<path>
local function real_path(name)
  local root, path = name:match("^diffview://(.-)/%.git/[^/]*:/(.+)$")
  return root and (root .. "/" .. path) or nil
end

-- Ánh xạ số dòng bản cũ sang bản hiện tại, nil nếu dòng đã bị xoá
local function map_line(old_lines, new_lines, line)
  local hunks = vim.diff(table.concat(old_lines, "\n") .. "\n", table.concat(new_lines, "\n") .. "\n", { result_type = "indices" })
  local offset = 0
  for _, h in ipairs(hunks) do
    local start_a, count_a, start_b, count_b = unpack(h)
    local first = count_a > 0 and start_a or start_a + 1
    if line < first then break end
    if count_a > 0 and line < start_a + count_a then
      if count_b == 0 then return nil end
      return math.min(start_b + (line - start_a), start_b + count_b - 1)
    end
    offset = offset + count_b - count_a
  end
  return line + offset
end

-- Lấy kết quả đầu tiên không rỗng từ các LSP client
local function first_result(results)
  for client_id, res in pairs(results) do
    if res.result and not vim.tbl_isempty(res.result) then return client_id, res.result end
  end
end

-- Nhảy tới vị trí đơn, nhiều vị trí thì đưa vào quickfix
local function show_locations(client_id, result)
  local locations = (result.uri or result.targetUri) and { result } or result
  local encoding = vim.lsp.get_client_by_id(client_id).offset_encoding
  if #locations == 1 then
    vim.lsp.util.show_document(locations[1], encoding, { reuse_win = true, focus = true })
    return
  end
  vim.fn.setqflist({}, " ", { title = "LSP", items = vim.lsp.util.locations_to_items(locations, encoding) })
  vim.cmd("copen")
end

local function request(method)
  local buf = vim.api.nvim_get_current_buf()
  local path = real_path(vim.api.nvim_buf_get_name(buf))
  if not path or vim.fn.filereadable(path) == 0 then
    vim.notify("File thật không còn trong worktree", vim.log.levels.WARN)
    return
  end
  local real = vim.fn.bufadd(path)
  vim.fn.bufload(real)
  local row = map_line(
    vim.api.nvim_buf_get_lines(buf, 0, -1, false),
    vim.api.nvim_buf_get_lines(real, 0, -1, false),
    vim.api.nvim_win_get_cursor(0)[1]
  )
  if not row then
    vim.notify("Dòng này đã bị xoá khỏi bản hiện tại", vim.log.levels.INFO)
    return
  end
  local function params(client)
    local p = vim.lsp.util.make_position_params(0, client.offset_encoding)
    p.textDocument.uri = vim.uri_from_bufnr(real)
    p.position.line = row - 1
    return p
  end
  vim.lsp.buf_request_all(real, method, params, function(results)
    local client_id, result = first_result(results)
    if not client_id then
      vim.notify("Không có kết quả LSP", vim.log.levels.INFO)
      return
    end
    if method == HOVER then
      vim.lsp.util.open_floating_preview(vim.lsp.util.convert_input_to_markdown_lines(result.contents), "markdown", { focus_id = HOVER })
    else
      show_locations(client_id, result)
    end
  end)
end

-- Chỉ gắn proxy khi buffer chưa có LSP client; client attach sau sẽ ghi đè bằng keymap LSP thường
local function map_proxy(buf)
  if not real_path(vim.api.nvim_buf_get_name(buf)) or #vim.lsp.get_clients({ bufnr = buf }) > 0 then return end
  for lhs, key in pairs(KEYS) do
    vim.keymap.set("n", lhs, function() request(key.method) end, { buffer = buf, desc = key.desc })
  end
end

function M.setup()
  vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "diffview://*",
    callback = function(ev) map_proxy(ev.buf) end,
  })
end

return M

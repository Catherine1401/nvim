-- Tự cuộn log dev của flutter-tools xuống cuối như tail -f, dừng khi người dùng cuộn lên đọc
local M = {}

-- Dòng thấp nhất vừa thêm vào mỗi buffer đang chờ xử lý
local pending = {}

-- Chỉ cuộn cửa sổ nào đang đứng ở cuối log trước khi dòng mới được thêm
local function follow(buf)
  local first = pending[buf]
  pending[buf] = nil
  if not first or not vim.api.nvim_buf_is_valid(buf) then return end
  local last = vim.api.nvim_buf_line_count(buf)
  for _, win in ipairs(vim.fn.win_findbuf(buf)) do
    if vim.api.nvim_win_get_cursor(win)[1] >= first then vim.api.nvim_win_set_cursor(win, { last, 0 }) end
  end
end

local function on_lines(_, buf, _, first)
  local queued = pending[buf]
  if queued then
    pending[buf] = math.min(queued, first)
  else
    pending[buf] = first
    vim.schedule(function() follow(buf) end)
  end
end

local function attach(event)
  local LOG_NAME = "__FLUTTER_DEV_LOG__"
  local ATTACHED = "flutter_log_follow"
  local buf = event.buf
  if not vim.api.nvim_buf_get_name(buf):find(LOG_NAME, 1, true) then return end
  if vim.b[buf][ATTACHED] then return end
  vim.b[buf][ATTACHED] = true
  vim.api.nvim_buf_attach(buf, false, { on_lines = on_lines })
end

function M.setup()
  vim.api.nvim_create_autocmd("FileType", { pattern = "log", callback = attach })
end

return M

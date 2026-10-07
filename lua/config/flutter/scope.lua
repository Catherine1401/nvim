-- Phân biệt widget của project với widget do framework, Flutter SDK hoặc package tự dựng, theo vị trí tạo widget
local M = {}

local SYNTHETIC_ID = "config-flutter-scope-root"
local SYNTHETIC_NAME = "[app]"

-- Thư mục không thuộc mã của user: pub cache và Flutter SDK (suy ra từ lệnh flutter trong PATH)
local function system_dirs()
  local dirs = { vim.fs.normalize(vim.env.PUB_CACHE or "~/.pub-cache") }
  local flutter = vim.fn.exepath("flutter")
  if flutter ~= "" then
    local real = vim.uv.fs_realpath(flutter) or flutter
    dirs[#dirs + 1] = vim.fs.dirname(vim.fs.dirname(real))
  end
  return dirs
end

-- Vị trí tạo widget nằm ngoài các thư mục hệ thống thì là của user; không có vị trí thì coi là hệ thống
function M.is_user(location, dirs)
  if not location or not location.file then return false end
  local path = vim.fs.normalize(vim.uri_to_fname(location.file))
  for _, dir in ipairs(dirs or system_dirs()) do
    if vim.startswith(path, dir .. "/") then return false end
  end
  return true
end

-- Dựng cây chỉ gồm widget của user: widget hệ thống bị bỏ, con của nó nối lên tổ tiên của user gần nhất để cây vẫn phân cấp.
-- Trả về (gốc, tập valueId hiển thị); nil khi không có widget nào của user. Nhiều nhánh cao nhất thì thêm gốc giả
function M.user_tree(raw)
  local dirs = system_dirs()
  local visible = {}
  local function collect(node)
    local children = {}
    for _, child in ipairs(node.children or {}) do
      vim.list_extend(children, collect(child))
    end
    if not M.is_user(node.creationLocation, dirs) then return children end
    visible[node.valueId] = true
    return { vim.tbl_extend("force", node, { children = children }) }
  end
  local top = collect(raw)
  if #top == 0 then return nil end
  if #top == 1 then return top[1], visible end
  return { description = SYNTHETIC_NAME, valueId = SYNTHETIC_ID, children = top }, visible
end

return M

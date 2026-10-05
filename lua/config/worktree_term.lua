-- Mỗi worktree có terminal riêng, bật/tắt theo gốc worktree của cwd để shell luôn đứng đúng thư mục
local M = {}

-- Terminal đã tạo, khoá theo gốc worktree
local terms = {}

-- Gốc worktree chứa cwd, không phải repo git thì dùng chính cwd
local function root_of(cwd)
  local out = vim.fn.systemlist({ "git", "-C", cwd, "rev-parse", "--show-toplevel" })
  return vim.v.shell_error == 0 and out[1] or cwd
end

function M.toggle()
  local root = root_of(vim.fn.getcwd())
  -- Đóng terminal của worktree khác để không chồng cửa sổ
  for dir, term in pairs(terms) do
    if dir ~= root and term:is_open() then term:close() end
  end
  if not terms[root] then
    terms[root] = require("toggleterm.terminal").Terminal:new({
      dir = root,
      display_name = vim.fn.fnamemodify(root, ":t"),
    })
  end
  terms[root]:toggle()
end

return M

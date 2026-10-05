-- Lock file của claudecode.nvim liệt kê mọi worktree và cập nhật khi đổi cwd, để claude ở worktree nào cũng nối được
local M = {}

-- Thêm các worktree của repo hiện tại vào danh sách thư mục, bỏ qua thư mục trùng
local function add_worktrees(folders)
  for _, line in ipairs(vim.fn.systemlist({ "git", "worktree", "list", "--porcelain" })) do
    local path = line:match("^worktree (.+)$")
    if path and not vim.tbl_contains(folders, path) then table.insert(folders, path) end
  end
  return folders
end

function M.setup()
  local lockfile = require("claudecode.lockfile")
  local original = lockfile.get_workspace_folders
  lockfile.get_workspace_folders = function() return add_worktrees(original()) end

  -- Ghi lại lock với cùng port và token khi cwd đổi (vd. chuyển worktree)
  vim.api.nvim_create_autocmd("DirChanged", {
    callback = function()
      local state = require("claudecode").state
      if state.server then lockfile.create(state.port, state.auth_token) end
    end,
  })
end

return M

-- lua/config/diag_filter.lua

-- Bỏ diagnostics của file chưa mở để nvim không tạo hàng trăm buffer làm chậm bufferline
local PUBLISH_METHOD = "textDocument/publishDiagnostics"

local function is_open(uri)
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.uri_from_bufnr(buf) == uri then
      return true
    end
  end
  return false
end

return function(err, result, ctx, ...)
  if result and result.uri and not is_open(result.uri) then
    return
  end
  return vim.lsp.handlers[PUBLISH_METHOD](err, result, ctx, ...)
end

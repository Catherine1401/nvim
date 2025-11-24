-- lua/config/autocmds.lua

-- Hàm tiện ích để tạo nhóm Autocmd (tránh bị trùng lặp khi reload config)
local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

-- ============================================================================
-- 1. HIGHLIGHT KHI COPY (YANK HIGHLIGHT) - CỰC QUAN TRỌNG
-- ============================================================================
-- Khi cậu copy (y), đoạn văn bản sẽ sáng lên trong tích tắc
-- Giúp cậu biết chính xác mình đã copy cái gì.
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

-- ============================================================================

-- ============================================================================
-- 3. NHỚ VỊ TRÍ CON TRỎ (RESTORE CURSOR)
-- ============================================================================
-- Khi mở lại một file cũ, con trỏ sẽ nhảy ngay đến dòng cậu đang code dở
-- thay vì quay về dòng đầu tiên.
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
      return
    end
    vim.b[buf].lazyvim_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- ============================================================================
-- 4. ĐÓNG CỬA SỔ BẰNG PHÍM 'q' (CLOSE WITH Q)
-- ============================================================================
-- Với các loại cửa sổ phụ (Help, Man page, LSP Info, Notify...),
-- cậu chỉ cần bấm 'q' là đóng, không cần gõ :q hay :close.
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf", -- Quickfix list
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "checkhealth",
    "dap-float", -- Debugger float
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- ============================================================================

-- ============================================================================
-- 6. TỰ ĐỘNG CẬP NHẬT FILE (CHECKTIME)
-- ============================================================================
-- Nếu file bị thay đổi từ bên ngoài (ví dụ cậu switch branch bằng Git),
-- Neovim sẽ tự động load lại nội dung mới ngay khi cậu focus vào cửa sổ.
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  command = "checktime",
})

-- ============================================================================
-- 7. CẤU HÌNH RIÊNG CHO FILE TEXT/MARKDOWN
-- ============================================================================
-- Tự động bật Wrap (xuống dòng) và kiểm tra chính tả cho file Markdown/GitCommit
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("wrap_spell"),
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = false -- Tớ tắt spell check vì tiếng Việt hay bị báo lỗi đỏ
  end,
})

vim.diagnostic.config({
  signs = true,
  underline = true
})

local function toggle_visual_diagnostics()
  -- Lấy cấu hình hiện tại
  local current_config = vim.diagnostic.config()

  -- 🌟 SỬA LỖI: Kiểm tra xem virtual_text có phải là bảng (table) không 🌟
  -- Nếu là table, kiểm tra trường enabled hoặc prefix.
  -- Nếu là boolean, kiểm tra trực tiếp giá trị boolean đó.
  local is_enabled = false
  if type(current_config.virtual_text) == 'table' then
    -- Nếu là bảng, coi như đang bật nếu không bị disable rõ ràng
    is_enabled = current_config.virtual_text.enabled ~= false
  elseif type(current_config.virtual_text) == 'boolean' then
    -- Nếu là boolean, coi như đang bật nếu nó là true
    is_enabled = current_config.virtual_text == true
  end


  if is_enabled then
    -- TRẠNG THÁI LÀ BẬT -> TẮT VIRTUAL TEXT
    vim.diagnostic.config({
      virtual_text = false, -- Tắt bằng boolean
      -- signs = false,        -- Tắt signs
      -- underline = false,    -- Tắt underline
    })
  else
    -- TRẠNG THÁI LÀ TẮT -> BẬT VIRTUAL TEXT
    vim.diagnostic.config({
      -- Bật với đầy đủ cấu hình table (để không bị lỗi boolean lần sau)
      virtual_text = {
        enabled = true,
        prefix = '  ',
        severity = { min = vim.diagnostic.severity.HINT },
      },
      -- signs = true,         -- Bật signs
      -- underline = true,     -- Bật underline
    })
  end
end

vim.keymap.set('n', '<leader>dt', toggle_visual_diagnostics, { desc = 'Toggle Virtual Text Diagnostics' })

local on_attach_handler = function(client, bufnr)
  -- Tùy chọn cho keymap (chỉ áp dụng cho buffer hiện tại)
  local opts = { noremap = true, silent = true, buffer = bufnr }

  -- 1. Thiết lập các thao tác di chuyển/tra cứu (Navigation/Lookup)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)      -- Go to Definition (Đi đến định nghĩa)
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)     -- Go to Declaration (Đi đến khai báo)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)  -- Go to Implementation (Đi đến triển khai)
  vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, opts) -- Go to Type Definition (Đi đến định nghĩa kiểu)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)      -- Go to References (Tìm các tham chiếu)

  -- Ghi đè phím K (Hover) để xem thông tin nhanh, và đặt lại phím mặc định của Neovim
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts) -- K: Hiển thị tài liệu/thông tin nhanh (Hover)

  -- 2. Thiết lập các thao tác sửa chữa/hành động (Actions)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts) -- <leader>ca: Code Action (Hành động mã)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)      -- <leader>rn: Rename (Đổi tên biến/hàm)
  vim.keymap.set({ 'n', 'v' }, '<leader>ff', function()
    vim.lsp.buf.format({ async = true })
  end, opts)
  -- 3. Thiết lập các thao tác chẩn đoán lỗi (Diagnostics)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)         -- [d: Đi đến lỗi/cảnh báo trước
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)         -- ]d: Đi đến lỗi/cảnh báo tiếp theo
  vim.keymap.set('n', '<leader>D', vim.diagnostic.open_float, opts) -- <leader>D: Mở cửa sổ chi tiết lỗi

  -- 4. Thiết lập các thao tác đặc biệt
  vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, opts) -- <C-k> (Insert mode): Hiển thị trợ giúp hàm (Signature Help)

  -- 5. Xóa/Vô hiệu hóa các cài đặt mặc định không cần thiết (Buffer-Local)
  -- Giúp tránh xung đột và dùng các plugin khác (ví dụ: gq cho formatting)
  vim.bo[bufnr].formatexpr = nil
  -- vim.bo[bufnr].omnifunc = nil -- Có thể bỏ dòng này nếu cậu muốn dùng cmp.
  -- vim.lsp.document_color.enable(false, bufnr) -- Bỏ comment nếu cậu muốn tắt tô sáng màu
end

-- Sau đó, cậu truyền hàm này vào cấu hình lspconfig của mình
-- Ví dụ cho Lua Language Server (lua_ls):
require('lspconfig').lua_ls.setup {
  on_attach = on_attach_handler,
  -- ... các tùy chọn khác
}

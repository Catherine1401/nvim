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

-- ============================================================================
-- 8. CHẾ ĐỘ FILE LỚN (LARGE FILE GUARD)
-- ============================================================================
-- File quá to (generated code, bundle, log, .g.dart, .freezed.dart...) sẽ làm
-- treo Neovim vì mọi plugin bám theo buffer đều phải tính lại liên tục.
-- Khi vượt ngưỡng, đặt cờ vim.b.large_file và tắt các thứ tốn tài nguyên.
-- Cờ này cũng được lua/plugins/highlight.lua dùng để bỏ qua treesitter.

local LARGE_FILE_SIZE = 1024 * 1024 -- 1 MB

vim.api.nvim_create_autocmd("BufReadPre", {
  group = augroup("large_file"),
  callback = function(event)
    local ok, stats = pcall((vim.uv or vim.loop).fs_stat, vim.api.nvim_buf_get_name(event.buf))
    if not (ok and stats and stats.size > LARGE_FILE_SIZE) then
      return
    end

    vim.b[event.buf].large_file = true

    -- Cờ chuẩn của mini.nvim để tắt cho riêng buffer này
    vim.b[event.buf].minicursorword_disable = true
    vim.b[event.buf].miniindentscope_disable = true

    vim.bo[event.buf].swapfile = false
    vim.bo[event.buf].undofile = false

    -- Đặt sau khi filetype đã được nhận diện, nếu không syntax bị bật lại
    vim.api.nvim_create_autocmd("BufWinEnter", {
      buffer = event.buf,
      once = true,
      callback = function()
        -- Tắt syntax regex (treesitter đã bị chặn bởi cờ large_file ở highlight.lua)
        vim.bo.syntax = ""
        vim.opt_local.foldmethod = "manual"
        vim.opt_local.spell = false
        vim.opt_local.list = false
        vim.opt_local.relativenumber = false -- redraw số dòng tương đối rất tốn khi cuộn
        vim.opt_local.cursorline = false
        vim.opt_local.colorcolumn = ""
      end,
    })

    vim.notify(
      string.format("File lớn (%.1f MB) - đã bật chế độ nhẹ", stats.size / 1024 / 1024),
      vim.log.levels.WARN,
      { title = "Large file" }
    )
  end,
})

vim.diagnostic.config({
  signs = true,
  underline = true
})

-- local function toggle_visual_diagnostics()
--   -- Lấy cấu hình hiện tại
--   local current_config = vim.diagnostic.config()

--   -- 🌟 SỬA LỖI: Kiểm tra xem virtual_text có phải là bảng (table) không 🌟
--   -- Nếu là table, kiểm tra trường enabled hoặc prefix.
--   -- Nếu là boolean, kiểm tra trực tiếp giá trị boolean đó.
--   local is_enabled = false
--   if type(current_config.virtual_text) == 'table' then
--     -- Nếu là bảng, coi như đang bật nếu không bị disable rõ ràng
--     is_enabled = current_config.virtual_text.enabled ~= false
--   elseif type(current_config.virtual_text) == 'boolean' then
--     -- Nếu là boolean, coi như đang bật nếu nó là true
--     is_enabled = current_config.virtual_text == true
--   end


--   if is_enabled then
--     -- TRẠNG THÁI LÀ BẬT -> TẮT VIRTUAL TEXT
--     vim.diagnostic.config({
--       virtual_text = false, -- Tắt bằng boolean
--       -- signs = false,        -- Tắt signs
--       -- underline = false,    -- Tắt underline
--     })
--   else
--     -- TRẠNG THÁI LÀ TẮT -> BẬT VIRTUAL TEXT
--     vim.diagnostic.config({
--       -- Bật với đầy đủ cấu hình table (để không bị lỗi boolean lần sau)
--       virtual_text = {
--         enabled = true,
--         prefix = '  ',
--         severity = { min = vim.diagnostic.severity.HINT },
--       },
--       -- signs = true,         -- Bật signs
--       -- underline = true,     -- Bật underline
--     })
--   end
-- end

-- vim.keymap.set('n', '<leader>dt', toggle_visual_diagnostics, { desc = 'Toggle Virtual Text Diagnostics' })


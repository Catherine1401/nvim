return {
  -- ==========================================================================
  -- 1. RENDER MARKDOWN (Render đẹp ngay trong Neovim - WYSIWYG)
  -- ==========================================================================
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "norg", "rmd", "org" }, -- Chỉ tải khi mở file Markdown
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons", -- Icon đẹp
    },
    opts = {
      -- 1. CẤU HÌNH TIÊU ĐỀ (HEADINGS) - Style Notion/Obsidian
      heading = {
        sign = false, -- Tắt ký tự # ở lề trái (Anti-conceal sẽ hiện lại khi sửa)
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " }, -- Icon số đẹp 1->6
        position = "inline", -- Icon nằm ngay dòng tiêu đề
        border = true, -- Kẻ đường viền dưới chân tiêu đề (chuyên nghiệp)
        width = "block", -- Nền màu bao quanh chữ
        left_margin = 0, -- Thụt lề một chút
        left_pad = 2,
        right_pad = 2,
      },

      -- 2. CẤU HÌNH CODE BLOCK - Style VS Code
      code = {
        sign = false,
        width = "block",    -- Full chiều rộng
        right_pad = 2,
        style = "language", -- Hiện tên ngôn ngữ
        position = "left", -- Tên ngôn ngữ nằm bên phải
        border = "thick",   -- Viền dày nổi bật
      },

      -- 3. CẤU HÌNH DANH SÁCH (BULLETS)
      bullet = {
        icons = { "●", "○", "◆", "◇" },
        left_pad = 0,
        right_pad = 1,
      },

      -- 4. CẤU HÌNH CHECKBOX
      checkbox = {
        unchecked = { icon = "󰄱 " },
        checked = { icon = "󰱒 " },
        custom = {
          todo = { raw = "[-]", rendered = "󰥔 ", highlight = "RenderMarkdownTodo" },
        },
      },

      -- 5. CẤU HÌNH TRÍCH DẪN (QUOTE)
      quote = {
        icon = "▋",
        repeat_linebreak = true,
      },

      -- 6. CẤU HÌNH BẢNG (TABLE)
      pipe_table = {
        style = "full",
        cell = "padded",
        border = { "┌", "┬", "┐", "├", "┼", "┤", "└", "┴", "┘", "│", "─" },
      },

      -- 7. CẤU HÌNH CALLOUT (Ghi chú đẹp)
      callout = {
        note      = { raw = "[!NOTE]", rendered = "󰋽 Note", highlight = "RenderMarkdownInfo" },
        tip       = { raw = "[!TIP]", rendered = "󰌶 Tip", highlight = "RenderMarkdownSuccess" },
        warning   = { raw = "[!WARNING]", rendered = "󰀪 Warning", highlight = "RenderMarkdownWarn" },
        important = { raw = "[!IMPORTANT]", rendered = "󰅾 Important", highlight = "RenderMarkdownHint" },
        caution   = { raw = "[!CAUTION]", rendered = "󰳦 Caution", highlight = "RenderMarkdownError" },
      },

      -- 8. CẤU HÌNH LIÊN KẾT (LINKS)
      link = {
        enabled = true,
        footnote = { superscript = true, prefix = "", suffix = "" },
        image = "󰥶 ",
        email = "󰀓 ",
        hyperlink = "󰌹 ",
        custom = {
          web = { pattern = "^http", icon = "󰖟 " },
          youtube = { pattern = "youtube%.com", icon = "󰗃 " },
          github = { pattern = "github%.com", icon = "󰊤 " },
        },
      },

      -- 9. TÍNH NĂNG ANTI-CONCEAL (Cốt lõi)
      -- Ẩn ký tự thừa khi đọc, hiện lại khi đưa con trỏ vào để sửa
      anti_conceal = {
        enabled = true,
      },
    },
  },

  -- ==========================================================================
  -- 2. MARKDOWN PREVIEW (Xem Live trên trình duyệt)
  -- ==========================================================================
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },

    -- Tự động cài đặt dependencies (yarn/npm) khi cài plugin
     build = "cd app && npm install",

    init = function()
      -- Cấu hình biến toàn cục cho Markdown Preview (theo docs)
      vim.g.mkdp_filetypes = { "markdown" }
      vim.g.mkdp_auto_close = 0 -- Không tự đóng trình duyệt khi chuyển tab (giữ live preview)
      vim.g.mkdp_theme = 'dark' -- Giao diện tối cho trình duyệt
    end,

    keys = {
      {
        "<leader>mp",
        "<cmd>MarkdownPreviewToggle<cr>",
        desc = "Bật/Tắt Preview Markdown (Trình duyệt)",
        ft = "markdown",
      },
    },
  },
}

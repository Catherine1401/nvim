return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8", -- Dùng bản tag ổn định thay vì branch master (theo khuyến nghị của docs)
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",

      -- Extension này giúp tìm kiếm NHANH HƠN CẢ NGƯỜI YÊU CŨ TRỞ MẶT
      -- Nó dùng thuật toán FZF viết bằng C.
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make"
      },
    },

    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")

      telescope.setup({
        -- 1. CẤU HÌNH MẶC ĐỊNH (DEFAULTS)
        defaults = {
          prompt_prefix = " ", -- Icon dòng nhắc lệnh
          selection_caret = " ", -- Icon dòng đang chọn
          path_display = { "truncate" }, -- Cắt bớt đường dẫn nếu quá dài

          -- Cấu hình Layout hiện đại (Thanh tìm kiếm ở trên cùng)
          sorting_strategy = "ascending",
          layout_config = {
            horizontal = {
              prompt_position = "top", -- Đưa thanh search lên trên
              preview_width = 0.55,    -- Chia tỉ lệ 55% cho màn hình xem trước
            },
            vertical = {
              mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },

          -- Cấu hình phím tắt TRONG LÚC tìm kiếm
          mappings = {
            i = { -- Chế độ Insert (đang gõ)
              ["<C-n>"] = actions.cycle_history_next,
              ["<C-p>"] = actions.cycle_history_prev,
              ["<C-j>"] = actions.move_selection_next,     -- Ctrl+j để xuống dưới
              ["<C-k>"] = actions.move_selection_previous, -- Ctrl+k để lên trên
              ["<C-c>"] = actions.close,                   -- Đóng nhanh
            },
            n = {                                          -- Chế độ Normal
              ["q"] = actions.close,                       -- Bấm q để thoát
            },
          },
        },

        -- 2. CẤU HÌNH TỪNG BỘ CHỌN (PICKERS)
        pickers = {
          find_files = {
            -- theme = "dropdown", -- Giao diện thả xuống nhỏ gọn cho tìm file
            previewer = true,                                                       -- Tắt preview cho gọn (hoặc để true nếu cậu thích)
            hidden = true,                                                          -- Tìm cả file ẩn (bắt đầu bằng dấu chấm)
            find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" }, -- Bỏ qua folder .git
          },
          live_grep = {
            theme = "ivy", -- Giao diện dạng ngăn kéo (drawer) ở dưới đáy cho tìm text
          },
          buffers = {
            -- theme = "dropdown",
            previewer = true,
            initial_mode = "normal", -- Mở lên ở chế độ Normal để xóa buffer nhanh
            mappings = {
              i = { ["<C-d>"] = actions.delete_buffer },
              n = { ["dd"] = actions.delete_buffer },
            },
          },
        },

        -- 3. CẤU HÌNH EXTENSIONS
        extensions = {
          fzf = {
            fuzzy = true,                   -- Bật tìm kiếm mờ (gõ sai vài chữ vẫn ra)
            override_generic_sorter = true, -- Ghi đè thuật toán sắp xếp mặc định
            override_file_sorter = true,    -- Ghi đè thuật toán sắp xếp file
            case_mode = "smart_case",       -- Tự động phân biệt hoa thường
          },
          -- Cấu hình cho Flutter (nếu cần chỉnh sâu hơn)
          flutter = {
            -- ...
          },
        },
      })

      -- 4. NẠP EXTENSIONS
      -- Bắt buộc phải load sau khi setup
      telescope.load_extension("fzf")   -- Load thuật toán tìm kiếm nhanh
      telescope.load_extension("noice") -- Load lịch sử thông báo

      -- Load các extension nếu có cài
      if pcall(require, "flutter-tools") then
        telescope.load_extension("flutter")
      end
      if pcall(require, "lazygit") then
        telescope.load_extension("lazygit")
      end
    end,

    -- 5. PHÍM TẮT (KEYMAPS)
    keys = {
      -- Tìm kiếm cơ bản
      { "<leader><leader>", "<cmd>Telescope find_files<cr>", desc = "Tìm file (Files)" },
      { "<leader>fw", "<cmd>Telescope live_grep<cr>", desc = "Tìm chữ (Word)" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Danh sách Buffer" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Tìm trợ giúp (Help)" },
      { "<leader>fo", "<cmd>Telescope oldfiles<cr>", desc = "File mở gần đây" },
      { "<leader>fc", "<cmd>Telescope grep_string<cr>", desc = "Tìm chữ tại con trỏ" },

      -- Git
      { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Git Commits" },
      { "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Git Status" },

      -- Tiện ích khác
      { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Tra cứu phím tắt" },
      { "<leader>ft", "<cmd>Telescope colorscheme<cr>", desc = "Đổi giao diện (Theme)" },
    },
  },
}

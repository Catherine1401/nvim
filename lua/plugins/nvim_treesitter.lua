-- nvim-treesitter branch "main" (bản viết lại cho Neovim 0.11+):
-- plugin CHỈ còn lo cài parser. Các option highlight/indent/incremental_selection/
-- auto_install/ensure_installed của branch "master" đã bị bỏ, truyền vào setup()
-- sẽ bị bỏ qua im lặng. Highlight phải tự bật bằng vim.treesitter.start().
return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main", -- Bắt buộc với Neovim 0.12
		build = ":TSUpdate",
		lazy = false,

		config = function()
			-- setup() ở branch main chỉ nhận install_dir.
			-- Mặc định ~/.local/share/nvim/site, dùng luôn cho gọn.
			require("nvim-treesitter").setup({})

			-- 1. CÀI PARSER
			-- Thay cho ensure_installed. Chỉ cài parser còn thiếu để mỗi lần khởi
			-- động không phải chạy lại tác vụ nền.
			local ensure_installed = {
				"c",
				"lua",
				"vim",
				"vimdoc",
				"query",
				"markdown",
				"markdown_inline",
				"dart", -- Flutter
				"c_sharp", -- .NET
				"go",
			}

			local installed = require("nvim-treesitter").get_installed("parsers")
			local missing = vim.tbl_filter(function(lang)
				return not vim.tbl_contains(installed, lang)
			end, ensure_installed)

			if #missing > 0 then
				require("nvim-treesitter").install(missing, { summary = true })
			end

			-- 2. BẬT HIGHLIGHT
			-- Đây cũng là chỗ duy nhất chèn được ngưỡng file lớn: file to mà bật
			-- treesitter thì parse rất tốn CPU, gây đơ lúc mở file và lúc gõ.
			local MAX_FILESIZE = 200 * 1024 -- 200 KB

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("treesitter_highlight", { clear = true }),
				callback = function(ev)
					-- Cờ do lua/config/autocmds.lua đặt cho file > 1 MB
					if vim.b[ev.buf].large_file then
						return
					end

					local ok, stats = pcall((vim.uv or vim.loop).fs_stat, vim.api.nvim_buf_get_name(ev.buf))
					if ok and stats and stats.size > MAX_FILESIZE then
						return
					end

					-- pcall vì parser có thể chưa cài xong, hoặc filetype không có parser
					pcall(vim.treesitter.start, ev.buf)
				end,
			})

			-- indent để tắt (easy-dotnet dùng GetCSIndent riêng), nên không đặt
			-- indentexpr = v:lua.require'nvim-treesitter'.indentexpr()
		end,
	},
}

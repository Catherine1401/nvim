return {
	{
		"jake-stewart/multicursor.nvim",
		branch = "1.0",
		-- Chỉ nạp khi dùng phím multicursor lần đầu, vì autocmd SafeState của plugin chạy ở mọi lần gõ phím
		keys = {
			{ "<up>", mode = { "n", "x" }, desc = "Thêm cursor phía trên" },
			{ "<down>", mode = { "n", "x" }, desc = "Thêm cursor phía dưới" },
			{ "<M-up>", mode = { "n", "x" }, desc = "Bỏ qua cursor phía trên" },
			{ "<M-down>", mode = { "n", "x" }, desc = "Bỏ qua cursor phía dưới" },
			{ "<leader>n", mode = { "n", "x" }, desc = "Thêm cursor ở match kế tiếp" },
			{ "<leader>,", mode = { "n", "x" }, desc = "Bỏ qua match kế tiếp" },
			{ "<leader>N", mode = { "n", "x" }, desc = "Thêm cursor ở match trước" },
			{ "<leader>S", mode = { "n", "x" }, desc = "Bỏ qua match trước" },
			{ "<c-q>", mode = { "n", "x" }, desc = "Bật/tắt cursor tại vị trí hiện tại" },
			{ "<leader>mA", mode = { "n", "x" }, desc = "Thêm cursor ở mọi match" },
			{ "<c-leftmouse>", mode = "n", desc = "Thêm/xóa cursor bằng chuột" },
			{ "ga", mode = "n", desc = "Thêm cursor theo operator" },
		},
		config = function()
			local mc = require("multicursor-nvim")
			mc.setup()

			local set = vim.keymap.set

			-- ======================================================================
			-- 1. BASIC USAGE (Cấu hình cơ bản từ Docs)
			-- ======================================================================

			-- Thêm hoặc bỏ qua con trỏ lên/xuống (Up/Down)
			set({ "n", "x" }, "<up>", function()
				mc.lineAddCursor(-1)
			end, { desc = "Add cursor above" })
			set({ "n", "x" }, "<down>", function()
				mc.lineAddCursor(1)
			end, { desc = "Add cursor below" })
			set({ "n", "x" }, "<M-up>", function()
				mc.lineSkipCursor(-1)
			end, { desc = "Skip cursor above" })
			set({ "n", "x" }, "<M-down>", function()
				mc.lineSkipCursor(1)
			end, { desc = "Skip cursor below" })

			-- Thêm hoặc bỏ qua con trỏ bằng cách khớp từ (Word Matching)
			set({ "n", "x" }, "<leader>n", function()
				mc.matchAddCursor(1)
			end, { desc = "Add next match" })
			set({ "n", "x" }, "<leader>,", function()
				mc.matchSkipCursor(1)
			end, { desc = "Skip next match" })
			set({ "n", "x" }, "<leader>N", function()
				mc.matchAddCursor(-1)
			end, { desc = "Add prev match" })
			set({ "n", "x" }, "<leader>S", function()
				mc.matchSkipCursor(-1)
			end, { desc = "Skip prev match" })

			-- Thêm/Xóa con trỏ bằng chuột (Mouse)
			set("n", "<c-leftmouse>", mc.handleMouse, { desc = "Thêm/xóa cursor bằng chuột" })
			set("n", "<c-leftdrag>", mc.handleMouseDrag, { desc = "Kéo cursor bằng chuột" })
			set("n", "<c-leftrelease>", mc.handleMouseRelease, { desc = "Thả cursor bằng chuột" })

			-- Tắt/Bật Multicursor (Chỉ di chuyển con trỏ chính)
			set({ "n", "x" }, "<c-q>", mc.toggleCursor, { desc = "Toggle Multicursor" })

			-- Keymap Layer: Chỉ hoạt động khi ĐANG CÓ nhiều con trỏ
			mc.addKeymapLayer(function(layerSet)
				-- Chọn con trỏ khác làm con trỏ chính
				layerSet({ "n", "x" }, "<left>", mc.prevCursor, { desc = "Chọn cursor trước" })
				layerSet({ "n", "x" }, "<right>", mc.nextCursor, { desc = "Chọn cursor kế tiếp" })

				-- Xóa con trỏ chính hiện tại
				layerSet({ "n", "x" }, "<leader>x", mc.deleteCursor, { desc = "Xóa cursor chính" })

				-- Phím Esc: Bật lại cursor nếu đang tắt, hoặc xóa hết cursor phụ
				layerSet("n", "<esc>", function()
					if not mc.cursorsEnabled() then
						mc.enableCursors()
					else
						mc.clearCursors()
					end
				end, { desc = "Bật lại hoặc xóa cursor phụ" })
			end)

			-- ======================================================================
			-- 2. ADVANCED ACTIONS (Các tính năng nâng cao từ Docs)
			-- ======================================================================

			-- Thêm con trỏ vào mỗi dòng của một đoạn văn (Paragraph)
			set("n", "ga", mc.addCursorOperator, { desc = "Add cursor operator (gaip)" })

			-- Thêm con trỏ cho TẤT CẢ các từ khớp trong file (Select All)
			set({ "n", "x" }, "<leader>mA", mc.matchAllAddCursors, { desc = "Add all matches" })

			-- ======================================================================
			-- 3. HIGHLIGHTS (Giao diện)
			-- ======================================================================
			local hl = vim.api.nvim_set_hl
			hl(0, "MultiCursorCursor", { reverse = true })
			hl(0, "MultiCursorVisual", { link = "Visual" })
			hl(0, "MultiCursorSign", { link = "SignColumn" })
			hl(0, "MultiCursorMatchPreview", { link = "Search" })
			hl(0, "MultiCursorDisabledCursor", { reverse = true })
			hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
			hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
		end,
	},
}

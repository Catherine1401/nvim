return {
	{
		"jake-stewart/multicursor.nvim",
		branch = "1.0",
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
			set("n", "<c-leftmouse>", mc.handleMouse)
			set("n", "<c-leftdrag>", mc.handleMouseDrag)
			set("n", "<c-leftrelease>", mc.handleMouseRelease)

			-- Tắt/Bật Multicursor (Chỉ di chuyển con trỏ chính)
			set({ "n", "x" }, "<c-q>", mc.toggleCursor, { desc = "Toggle Multicursor" })

			-- Keymap Layer: Chỉ hoạt động khi ĐANG CÓ nhiều con trỏ
			mc.addKeymapLayer(function(layerSet)
				-- Chọn con trỏ khác làm con trỏ chính
				layerSet({ "n", "x" }, "<left>", mc.prevCursor)
				layerSet({ "n", "x" }, "<right>", mc.nextCursor)

				-- Xóa con trỏ chính hiện tại
				layerSet({ "n", "x" }, "<leader>x", mc.deleteCursor)

				-- Phím Esc: Bật lại cursor nếu đang tắt, hoặc xóa hết cursor phụ
				layerSet("n", "<esc>", function()
					if not mc.cursorsEnabled() then
						mc.enableCursors()
					else
						mc.clearCursors()
					end
				end)
			end)

			-- ======================================================================
			-- 2. ADVANCED ACTIONS (Các tính năng nâng cao từ Docs)
			-- ======================================================================

			-- Thêm con trỏ vào mỗi dòng của một đoạn văn (Paragraph)
			set("n", "ga", mc.addCursorOperator, { desc = "Add cursor operator (gaip)" })

			-- Nhân bản con trỏ hiện tại và vô hiệu hóa con trỏ gốc
			set({ "n", "x" }, "<leader><c-q>", mc.duplicateCursors, { desc = "Duplicate cursors" })

			-- Căn chỉnh các con trỏ thẳng hàng (Align)
			set("n", "<leader>ma", mc.alignCursors, { desc = "Align cursors" })

			-- Tách vùng chọn bằng Regex (Split)
			set("x", "N", mc.splitCursors, { desc = "Split selections (Regex)" })

			-- Tạo con trỏ mới khớp với Regex trong vùng chọn (Match)
			set("x", "M", mc.matchCursors, { desc = "Match selections (Regex)" })

			-- Khôi phục con trỏ đã mất (Restore)
			set("n", "<leader>gv", mc.restoreCursors, { desc = "Restore cursors" })

			-- Thêm con trỏ cho TẤT CẢ các từ khớp trong file (Select All)
			set({ "n", "x" }, "<leader>mA", mc.matchAllAddCursors, { desc = "Add all matches" })

			-- Xoay nội dung giữa các con trỏ (Transpose)
			set("x", "<leader>tr", function()
				mc.transposeCursors(1)
			end, { desc = "Transpose next" })
			set("x", "<leader>tl", function()
				mc.transposeCursors(-1)
			end, { desc = "Transpose prev" })

			-- Chèn kiểu khối (Block Insertion) trong Visual mode
			set("x", "I", mc.insertVisual, { desc = "Insert visual" })
			set("x", "A", mc.appendVisual, { desc = "Append visual" })

			-- Tăng/Giảm số thứ tự (Sequence Increment)
			set({ "n", "x" }, "g<c-a>", mc.sequenceIncrement, { desc = "Sequence Increment" })
			set({ "n", "x" }, "g<c-x>", mc.sequenceDecrement, { desc = "Sequence Decrement" })

			-- Tìm kiếm và thêm con trỏ (Search Integration)
			set("n", "<leader>/n", function()
				mc.searchAddCursor(1)
			end, { desc = "Search add next" })
			set("n", "<leader>/N", function()
				mc.searchAddCursor(-1)
			end, { desc = "Search add prev" })
			set("n", "<leader>/s", function()
				mc.searchSkipCursor(1)
			end, { desc = "Search skip next" })
			set("n", "<leader>/S", function()
				mc.searchSkipCursor(-1)
			end, { desc = "Search skip prev" })
			set("n", "<leader>/A", mc.searchAllAddCursors, { desc = "Search add all" })

			-- Operator tùy chỉnh (Custom Operator)
			-- VD: <leader>miwap -> Tạo cursor cho mỗi từ trong đoạn văn
			set({ "n", "x" }, "<leader>m", mc.operator, { desc = "Multicursor Operator" })

			-- Tích hợp với Diagnostics (Lỗi/Cảnh báo)
			set({ "n", "x" }, "]d", function()
				mc.diagnosticAddCursor(1)
			end, { desc = "Add cursor next diagnostic" })
			set({ "n", "x" }, "[d", function()
				mc.diagnosticAddCursor(-1)
			end, { desc = "Add cursor prev diagnostic" })
			set({ "n", "x" }, "]s", function()
				mc.diagnosticSkipCursor(1)
			end, { desc = "Skip cursor next diagnostic" })
			set({ "n", "x" }, "[S", function()
				mc.diagnosticSkipCursor(-1)
			end, { desc = "Skip cursor prev diagnostic" })

			-- Chọn tất cả các lỗi Error trong đoạn (mdip)
			set({ "n", "x" }, "md", function()
				mc.diagnosticMatchCursors({ severity = vim.diagnostic.severity.ERROR })
			end, { desc = "Match diagnostics (Error)" })

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

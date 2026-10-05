return {
	"monkoose/neocodeium",
	event = "VeryLazy",
	config = function()
		local neocodeium = require("neocodeium")
		neocodeium.setup({
			enabled = false,
		})
		vim.keymap.set("i", "<A-f>", function()
			require("neocodeium").accept()
		end, { desc = "Chấp nhận gợi ý AI" })
		vim.keymap.set("i", "<A-w>", function()
			require("neocodeium").accept_word()
		end, { desc = "Chấp nhận một từ gợi ý AI" })
		vim.keymap.set("i", "<A-a>", function()
			require("neocodeium").accept_line()
		end, { desc = "Chấp nhận một dòng gợi ý AI" })
		vim.keymap.set("i", "<A-e>", function()
			require("neocodeium").cycle_or_complete()
		end, { desc = "Gợi ý AI kế tiếp" })
		vim.keymap.set("i", "<A-r>", function()
			require("neocodeium").cycle_or_complete(-1)
		end, { desc = "Gợi ý AI trước đó" })
		vim.keymap.set("i", "<A-c>", function()
			require("neocodeium").clear()
		end, { desc = "Xóa gợi ý AI" })
		vim.keymap.set("n", "<leader>at", function()
			require("neocodeium.commands").toggle()
			local status = require("neocodeium").get_status()
			local enabled = status == 0
			vim.notify(
				enabled and "NeoCodeium enabled" or "NeoCodeium disabled",
				enabled and vim.log.levels.INFO or vim.log.levels.WARN,
				{ title = "NeoCodeium" }
			)
		end, { desc = "Toggle NeoCodeium" })
	end,
}

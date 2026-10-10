-- lua/plugins/harpoon.lua
return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		require("harpoon"):setup()
	end,
	-- Nạp harpoon ở lần bấm phím đầu tiên thay vì lúc khởi động
	keys = {
		{ "<leader>ha", function() require("harpoon"):list():add() end, desc = "Harpoon add file" },
		{ "<leader>hh", function() local h = require("harpoon") h.ui:toggle_quick_menu(h:list()) end, desc = "Harpoon menu" },
		{ "<leader>1", function() require("harpoon"):list():select(1) end, desc = "Harpoon go to 1" },
		{ "<leader>2", function() require("harpoon"):list():select(2) end, desc = "Harpoon go to 2" },
		{ "<leader>3", function() require("harpoon"):list():select(3) end, desc = "Harpoon go to 3" },
		{ "<leader>4", function() require("harpoon"):list():select(4) end, desc = "Harpoon go to 4" },
	},
}

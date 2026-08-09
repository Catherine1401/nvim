return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	opts = {
		check_ts = true,
		ts_config = {
			lua = { "string", "source" },
			javascript = { "string", "template_string" },
			java = false,
		},
		disable_filetype = { "TelescopePrompt", "spectre_panel" },
		fast_wrap = {
			map = "<M-e>",
			chars = { "{", "[", "(", '"', "'" },
			pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
			offset = 0,
			end_key = "$",
			keys = "qwertyuiopzxcvbnmasdfghjkl",
			check_comma = true,
			highlight = "PmenuSel",
			highlight_grey = "LineNr",
		},
		map_cr = true,
	},
	config = function(_, opts)
		local autopairs = require("nvim-autopairs")
		autopairs.setup(opts)
		-- local cmp_status_ok, cmp = pcall(require, "cmp")
		-- if cmp_status_ok then
		--   local cmp_autopairs = require("nvim-autopairs.completion.cmp")
		--   cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		-- end
	end,
}

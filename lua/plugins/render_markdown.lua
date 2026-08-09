return {
	"MeanderingProgrammer/render-markdown.nvim",
	ft = { "markdown", "norg", "rmd", "org" },
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	opts = {
		heading = {
			sign = false,
			icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
			position = "inline",
			border = true,
			width = "block",
			left_margin = 0,
			left_pad = 2,
			right_pad = 2,
		},

		code = {
			sign = false,
			width = "block",
			right_pad = 2,
			style = "language",
			position = "left",
			border = "thick",
		},

		bullet = {
			icons = { "●", "○", "◆", "◇" },
			left_pad = 0,
			right_pad = 1,
		},

		checkbox = {
			unchecked = { icon = "󰄱 " },
			checked = { icon = "󰱒 " },
			custom = {
				todo = { raw = "[-]", rendered = "󰥔 ", highlight = "RenderMarkdownTodo" },
			},
		},

		quote = {
			icon = "▋",
			repeat_linebreak = true,
		},

		pipe_table = {
			style = "full",
			cell = "padded",
			border = { "┌", "┬", "┐", "├", "┼", "┤", "└", "┴", "┘", "│", "─" },
		},

		callout = {
			note = { raw = "[!NOTE]", rendered = "󰋽 Note", highlight = "RenderMarkdownInfo" },
			tip = { raw = "[!TIP]", rendered = "󰌶 Tip", highlight = "RenderMarkdownSuccess" },
			warning = { raw = "[!WARNING]", rendered = "󰀪 Warning", highlight = "RenderMarkdownWarn" },
			important = { raw = "[!IMPORTANT]", rendered = "󰅾 Important", highlight = "RenderMarkdownHint" },
			caution = { raw = "[!CAUTION]", rendered = "󰳦 Caution", highlight = "RenderMarkdownError" },
		},

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

		anti_conceal = {
			enabled = true,
		},
	},
}

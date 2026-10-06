return {
	"MeanderingProgrammer/render-markdown.nvim",
	ft = { "markdown", "norg", "rmd", "org" },
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	keys = {
		{ "<leader>mr", "<cmd>RenderMarkdown buf_toggle<cr>", ft = "markdown", desc = "Bật/tắt xem Markdown đã render" },
	},
	opts = {
		-- Mặc định xem raw; chỉ render khi tự bật bằng <leader>mr, và giữ nguyên ở mọi mode
		enabled = false,
		render_modes = true,

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

		-- Không tự trả dòng con trỏ về raw: hai chế độ xem tách biệt hoàn toàn
		anti_conceal = {
			enabled = false,
		},
	},
}

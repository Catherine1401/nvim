return {
	"iamcco/markdown-preview.nvim",
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	ft = { "markdown" },

	build = "cd app && npm install",

	init = function()
		vim.g.mkdp_filetypes = { "markdown" }
		vim.g.mkdp_auto_close = 0
		vim.g.mkdp_theme = 'dark'
	end,

	keys = {
		{
			"<leader>mp",
			"<cmd>MarkdownPreviewToggle<cr>",
			desc = "Bật/Tắt Preview Markdown (Trình duyệt)",
			ft = "markdown",
		},
	},
}

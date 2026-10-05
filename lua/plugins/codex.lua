return {
	"jaju/neovim-codex",
	main = "neovim_codex",
	dependencies = { "MunifTanjim/nui.nvim" },
	config = true,
	lazy = false,
	keys = {
		{ "<leader>oc", "<cmd>CodexChat<cr>", desc = "Codex: Toggle chat" },
		{ "<leader>ob", "<cmd>CodexCapturePath<cr>", desc = "Codex: Add current file" },
		{ "<leader>os", "<cmd>CodexCaptureSelection<cr>", desc = "Codex: Add selection", mode = "x" },
		{ "<leader>od", "<cmd>CodexCaptureDiagnostic<cr>", desc = "Codex: Add diagnostic" },
		{ "<leader>op", "<cmd>CodexCompose<cr>", desc = "Codex: Compose context" },
		{ "<leader>or", "<cmd>CodexRequest<cr>", desc = "Codex: Open pending request" },
		{ "<leader>oi", "<cmd>CodexInterrupt<cr>", desc = "Codex: Interrupt turn" },
		{ "<leader>oq", "<cmd>CodexStop<cr>", desc = "Codex: Stop app-server" },
	},
}

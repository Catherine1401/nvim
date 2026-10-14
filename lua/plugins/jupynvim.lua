return {
	"sheng-tse/jupynvim",
	lazy = false,
	tag = "v0.4.6",
	build = function(plugin)
		dofile(plugin.dir .. "/lua/jupynvim/install.lua").run(plugin)
	end,
	opts = function()
		local opts = { image_renderer = "placeholder", keymaps = {} }
		for action in pairs(require("jupynvim.notebook.keymaps").defaults) do
			opts.keymaps[action] = false
		end
		opts.keymaps.run_stay = "<leader>hr"
		opts.keymaps.run_all = "<leader>ha"
		opts.keymaps.pick_kernel = "<leader>hk"
		opts.keymaps.interrupt_kernel = "<leader>hi"
		opts.keymaps.restart_kernel = "<leader>hx"
		opts.keymaps.to_markdown = "<leader>hm"
		opts.keymaps.to_code = "<leader>hc"
		opts.keymaps.move_up = "<leader>hu"
		opts.keymaps.move_down = "<leader>hd"
		return opts
	end,
}

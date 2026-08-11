return {
	"folke/snacks.nvim",
	---@type snacks.Config
	opts = {
		image = {
			enabled = true,
			formats = {
				"png",
				"jpg",
				"jpeg",
				"gif",
				"bmp",
				"webp",
				"tiff",
				"heic",
				"avif",
				"mp4",
				"mov",
				"avi",
				"mkv",
				"webm",
				"pdf",
				"icns",
				"svg", -- thêm dòng này
			},
		},
		-- các module khác của bạn giữ nguyên...
	},
}

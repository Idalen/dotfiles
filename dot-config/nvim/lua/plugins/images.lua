return {
	"3rd/image.nvim",
	opts = {
		backend = "kitty",
		integrations = {
			markdown = {
				enabled = true,
				filetypes = { "markdown", "vimwiki" },
				only_render_image_at_cursor = false,
			},
			latex = {
				enabled = true,
				filetypes = { "tex", "latex" },
				only_render_image_at_cursor = false,
			},
			html = {
				enabled = true,
				only_render_image_at_cursor = false,
			},
		},
		hijack_file_patterns = {
			"*.png",
			"*.jpg",
			"*.jpeg",
			"*.gif",
			"*.webp",
			"*.svg",
			"*.ico",
			"*.bmp",
		},
		max_width = nil,
		max_height = nil,
		max_width_window_percentage = nil,
		max_height_window_percentage = 50,
	},
}

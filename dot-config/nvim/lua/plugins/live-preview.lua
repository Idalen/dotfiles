return {
	"brianhuster/live-preview.nvim",
	lazy = true,
	cmd = "LivePreview",
	keys = {
		{ "<leader>mp", "<cmd>LivePreview start<cr>", desc = "Markdown browser preview" },
		{ "<leader>mc", "<cmd>LivePreview close<cr>", desc = "Close browser preview" },
	},
}

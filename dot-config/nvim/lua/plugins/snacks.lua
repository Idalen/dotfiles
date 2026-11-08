return {
	"folke/snacks.nvim",
	lazy = false, -- load on startup so `Snacks` is available immediately
	priority = 1000,
	opts = {
		image = { enabled = true, doc = { enabled = false } },
		explorer = { enabled = false },
		statuscolumn = { enabled = true },
	},
}

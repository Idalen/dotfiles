--[[
Not really sure what this plugin does, but it is a hard dependency to run lazy.vim
]]

return {
	"folke/snacks.nvim",
	lazy = false, -- load on startup so `Snacks` is available immediately
	priority = 1000, -- load before LazyVim tries to use it
	opts = {
		explorer = { enabled = false },
	},
}

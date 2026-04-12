-- colorscheme plugin
return {
	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("kanagawa").setup()
			vim.cmd.colorscheme("kanagawa-wave")
		end,
	},

	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "kanagawa-wave",
		},
	},
}

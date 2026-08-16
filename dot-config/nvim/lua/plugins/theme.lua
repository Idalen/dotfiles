-- colorscheme plugin
return {
	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("kanagawa").setup({
				transparent = true, -- use the terminal's background
				colors = {
					theme = {
						all = {
							ui = {
								bg_gutter = "none", -- transparent line-number/sign/fold column
							},
						},
					},
				},
				overrides = function()
					return {
						NormalFloat = { bg = "none" },
						FloatBorder = { bg = "none" },
						FloatTitle = { bg = "none" },
						EndOfBuffer = { fg = "NONE" },
						CursorLine = { bg = "NONE" },
					}
				end,
			})
			vim.cmd.colorscheme("kanagawa-wave")
		end,
	},

	{
		"LazyVim/LazyVim",
		version = "15.15.0",
		opts = {
			colorscheme = "kanagawa-wave",
		},
	},
}

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
				overrides = function(colors)
					local ui = colors.theme.ui
					return {
						NormalFloat = { bg = "none" },
						FloatBorder = { bg = "none" },
						FloatTitle = { bg = "none" },
						EndOfBuffer = { fg = "NONE" },
						CursorLine = { bg = "NONE" },

						-- Telescope: keep the panel transparent, add a border and a
						-- clear selection bar so entries stay easy to tell apart
						TelescopeBorder = { fg = ui.float.fg_border, bg = "NONE" },
						TelescopeTitle = { fg = ui.fg, bg = "NONE", bold = true },
						TelescopeSelection = { bg = ui.bg_p2, bold = true },
						TelescopeSelectionCaret = { fg = ui.special, bg = ui.bg_p2 },
						TelescopeMatching = { fg = ui.special },
						TelescopePromptPrefix = { fg = ui.special },

						-- Trouble: match Telescope's selection bar for the current item
						TroubleCursorLine = { bg = ui.bg_p2 },
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

return {
	"nvim-treesitter/nvim-treesitter",
	dependecies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			textobjects = {
				move = {
					enable = true,
					set_jumps = true,
					goto_next_start = {
						["]m"] = "@function.outer",
					},
					goto_previous_start = {
						["[m"] = "@function.outer",
					},
				},
			},

			ensure_installed = { "c", "lua", "vim", "python", "rust", "bash", "terraform" }, -- Languages to always install
			sync_install = false,                          -- Install parsers asynchronously
			auto_install = true,                           -- Automatically install missing parsers on buffer open

			highlight = {
				enable = true, -- Enable Tree-sitter highlighting
				disable = { "yaml" }, -- Languages to disable highlighting for
			},
			indent = { enable = true }, -- Enable Tree-sitter based indentation
		})
	end,
}

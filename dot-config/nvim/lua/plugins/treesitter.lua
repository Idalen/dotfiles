return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = { "c", "lua", "vim", "python", "rust" }, -- Languages to always install
			sync_install = false,                  -- Install parsers asynchronously
			auto_install = true,                   -- Automatically install missing parsers on buffer open

			highlight = {
				enable = true, -- Enable Tree-sitter highlighting
				disable = { "yaml" }, -- Languages to disable highlighting for
			},
			indent = { enable = true }, -- Enable Tree-sitter based indentation
		})
	end,
}

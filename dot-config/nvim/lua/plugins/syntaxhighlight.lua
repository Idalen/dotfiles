return {
	"nvim-treesitter/nvim-treesitter",
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	lazy = false,
	build = ":TSUpdate",
	config = function()
		local treesitter = require("nvim-treesitter")
		treesitter.setup()
		treesitter.install({ "c", "lua", "vim", "python", "rust", "bash", "terraform" })

		-- Enable highlighting and indentation for installed parsers
		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "c", "lua", "vim", "python", "rust", "bash", "terraform" },
			callback = function()
				-- Enable syntax highlighting
				vim.treesitter.start()
				-- Enable treesitter-based indentation
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})

		-- Disable highlighting for yaml
		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "yaml" },
			callback = function()
				-- Disable treesitter highlighting for yaml
				vim.treesitter.stop()
			end,
		})

		-- Configure textobjects
		local textobjects = require("nvim-treesitter-textobjects")
		textobjects.setup({
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
		})
	end,
}

return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-neotest/nvim-nio",
			"nvim-treesitter/nvim-treesitter",
			"nvim-neotest/neotest-go",
		},
		config = function()
			local neotest = require("neotest")
			neotest.setup({
				adapters = {
					require("neotest-go")({
						experimental = {
							test_table = true,
						},
					}),
				},
			})

			local function map(lhs, rhs, desc)
				vim.keymap.set("n", lhs, rhs, { noremap = true, silent = true, desc = desc })
			end

			map("<leader>tn", function()
				neotest.run.run()
			end, "Test nearest")
			map("<leader>tf", function()
				neotest.run.run(vim.fn.expand("%"))
			end, "Test file")
			map("<leader>tp", function()
				neotest.run.run(vim.fn.getcwd())
			end, "Test package")
			map("<leader>ts", function()
				neotest.run.stop()
			end, "Test stop")
			map("<leader>to", function()
				neotest.output.open({ enter = true })
			end, "Test output")
			map("<leader>tO", function()
				neotest.output_panel.toggle()
			end, "Test output panel")
		end,
	},
}

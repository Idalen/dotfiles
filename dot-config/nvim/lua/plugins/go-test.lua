return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-neotest/nvim-nio",
			"nvim-treesitter/nvim-treesitter",
			"nvim-neotest/neotest-go",
			"nvim-neotest/neotest-plenary",
			"nvim-neotest/neotest-python",
			"alfaix/neotest-gtest",
		},
		config = function()
			local neotest = require("neotest")
			neotest.setup({
				output = {
					open_on_run = false,
				},
				adapters = {
					require("neotest-go"),
					require("neotest-plenary"),
					require("neotest-python")({
						dap = { justMyCode = false },
						runner = "pytest",
						python = vim.fn.expand("python3") or "python3",
					}),
					require("neotest-gtest").setup({}),
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
				neotest.output_panel.toggle()
			end, "Toggle test output")
		end,
	},
}

return {
	'nvim-telescope/telescope.nvim',
	tag = 'v0.2.0',
	dependencies = {
		'nvim-lua/plenary.nvim',
		'tpope/vim-fugitive',
		'nvim-tree/nvim-web-devicons',
	},
	config = function()
		local telescope = require("telescope")
		local builtin = require("telescope.builtin")

		telescope.setup({
			defaults = {
				wrap_results = true,
			},
		})

		vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
		vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
		vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
		vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Find help" })

		vim.keymap.set("n", "<leader>gc", builtin.git_commits, { desc = "Git commits" })
		vim.keymap.set("n", "<leader>gb", function()
			vim.cmd("Git blame --first-parent")
		end, { desc = "Git blame (first-parent)" })
		vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "Git status" })
	end
}

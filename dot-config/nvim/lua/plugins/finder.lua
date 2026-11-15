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
				get_selection_window = function(picker)
					local function is_code_window(win)
						return vim.api.nvim_win_is_valid(win)
							and vim.api.nvim_win_get_config(win).relative == ""
							and vim.bo[vim.api.nvim_win_get_buf(win)].buftype == ""
					end

					if is_code_window(picker.original_win_id) then
						return picker.original_win_id
					end
					-- Keep results out of sidebars that redirect file opens.
					for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
						if is_code_window(win) then
							return win
						end
					end
					vim.cmd("botright vnew")
					return vim.api.nvim_get_current_win()
				end,
				wrap_results = true,
				layout_strategy = "horizontal",
				layout_config = {
					horizontal = {
						prompt_position = "top",
						preview_width = 0.55,
					},
				},
				path_display = { "truncate" },
				dynamic_preview_title = true,
			},
		})

		vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
		vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
		vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
		vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Find help" })

		vim.keymap.set("n", "<leader>gc", builtin.git_commits, { desc = "Git commits" })
		vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "Git status" })
	end
}

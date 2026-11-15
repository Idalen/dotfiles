return {
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local gitsigns = require("gitsigns")

			gitsigns.setup({
				signs = {
					add = { text = "+" },
					change = { text = "~" },
					delete = { text = "_" },
					topdelete = { text = "-" },
					changedelete = { text = "~" },
				},
				current_line_blame = true,
				current_line_blame_opts = {
					delay = 200,
					virt_text_pos = "eol",
					ignore_whitespace = false,
				},
				current_line_blame_formatter = "  <author>, <author_time:%Y-%m-%d> • <summary>",
			})

			local map = vim.keymap.set
			map("n", "]c", gitsigns.next_hunk, { desc = "Next git hunk" })
			map("n", "[c", gitsigns.prev_hunk, { desc = "Prev git hunk" })
			map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Preview git hunk" })
			map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Stage git hunk" })
			map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Reset git hunk" })
			map("n", "<leader>hu", gitsigns.undo_stage_hunk, { desc = "Undo stage hunk" })
			map("n", "<leader>hb", gitsigns.toggle_current_line_blame, { desc = "Toggle line blame" })
		end,
	},
	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFileHistory" },
		keys = {
			{
				"<leader>gb",
				function()
					local file = vim.api.nvim_buf_get_name(0)
					if file == "" or vim.bo.buftype ~= "" then
						vim.notify("Open a file to browse its Git history", vim.log.levels.WARN)
						return
					end
					vim.cmd("DiffviewFileHistory " .. vim.fn.fnameescape(file))
				end,
				desc = "Git file history",
			},
			{ "<leader>gm", "<cmd>DiffviewOpen<CR>", desc = "Diff uncommitted changes" },
		},
		config = function()
			local dv = require("diffview")
			dv.setup({
				keymaps = {
					view = { { "n", "q", "<Cmd>DiffviewClose<CR>", { desc = "Close history" } } },
					file_panel = { { "n", "q", "<Cmd>DiffviewClose<CR>", { desc = "Close diff" } } },
					file_history_panel = { { "n", "q", "<Cmd>DiffviewClose<CR>", { desc = "Close history" } } },
				},
			})
		end,
	},
}

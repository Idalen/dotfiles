return {
	"OXY2DEV/markview.nvim",
	lazy = false,
	dependencies = { "saghen/blink.cmp" },
	config = function()
		vim.api.nvim_set_keymap("n", "<leader>mr", "<CMD>Markview<CR>",
			{ desc = "Toggles `markview` previews globally." });
		vim.api.nvim_set_keymap("i", "<Ctrl-m>", "<CMD>Markview HybridToggle<CR>",
			{ desc = "Toggles `hybrid mode` globally." });
		vim.api.nvim_set_keymap("n", "<leader>ms", "<CMD>Markview splitToggle<CR>",
			{ desc = "Toggles `splitview` for current buffer." });
	end
};

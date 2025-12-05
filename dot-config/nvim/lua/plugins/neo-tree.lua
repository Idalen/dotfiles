return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("neo-tree").setup({
				sort_function = function(a, b)
					-- Always put directories before files (optional)
					if a.type ~= b.type then
						return a.type == "directory"
					end

					-- Extract file extensions
					local ext_a = a.path:match("^.+%.(.+)$") or ""
					local ext_b = b.path:match("^.+%.(.+)$") or ""

					-- If extensions differ, sort by extension
					if ext_a ~= ext_b then
						return ext_a < ext_b
					end

					-- If same extension, sort by name
					return a.path:lower() < b.path:lower()
				end,
				window = {
					mappings = {
						["o"] = "open",
					}
				}
			})
		end,
	},
	{
		"antosha417/nvim-lsp-file-operations",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-neo-tree/neo-tree.nvim", -- makes sure that this loads after Neo-tree.
		},
		config = function()
			require("lsp-file-operations").setup()
		end,
	},
	{
		"s1n7ax/nvim-window-picker",
		version = "2.*",
		config = function()
			require("window-picker").setup({
				filter_rules = {
					include_current_win = false,
					autoselect_one = true,
					-- filter using buffer options
					bo = {
						-- if the file type is one of following, the window will be ignored
						filetype = { "neo-tree", "neo-tree-popup", "notify" },
						-- if the buffer type is one of following, the window will be ignored
						buftype = { "terminal", "quickfix" },
					},
				},
			})
		end,
	},
}

return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"gopls",
					"pyright",
					"ts_ls",
					"clangd",
				},
				automatic_installation = true,
			})

			local on_attach = function(_, bufnr)
				local opts = function(desc)
					return { noremap = true, silent = true, buffer = bufnr, desc = desc }
				end

				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts("Go to definition"))
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts("Go to declaration"))
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts("Implementation"))
				vim.keymap.set("n", "gr", vim.lsp.buf.references, opts("References"))

				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts("Hover"))
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts("Rename"))
				vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts("Code action"))

				vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts("Prev diagnostic"))
				vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts("Next diagnostic"))
				vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end,
					opts("Format"))
			end

			local defaults = {
				on_attach = on_attach,
				capabilities = vim.lsp.protocol.make_client_capabilities(),
			}


			-- helper: merge defaults into each server config
			local function with_defaults(opts)
				opts = opts or {}
				opts.on_attach = defaults.on_attach
				opts.capabilities = defaults.capabilities
				return opts
			end

			-- === Setup servers using new API === --

			-- Lua
			vim.lsp.config("lua_ls", with_defaults({
				settings = {
					Lua = {
						diagnostics = { globals = { "vim" } },
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false,
						},
					},
				},
			}))

			-- Go (gopls)
			vim.lsp.config("gopls", with_defaults({
				settings = {
					gopls = {
						usePlaceholders    = true, -- auto-insert param placeholders
						completeUnimported = true, -- suggest & import packages
						analyses           = {
							unusedparams = true,
							shadow       = true,
							nilness      = true,
							unusedwrite  = true,
						},
						staticcheck        = true, -- extra static analysis
						gofumpt            = true, -- stricter formatting
					},
				},
			}))
		end,
	},

	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		config = true,
	},
}

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
					"bashls",
					"julials",
					"terraformls"
				},
				automatic_installation = true,
			})

			local hover_group = vim.api.nvim_create_augroup("LspHoverPreview", { clear = false })

			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
				border = "rounded",
				focusable = false,
				close_events = { "CursorMoved", "InsertEnter", "BufLeave" },
			})

			local on_attach = function(_, bufnr)
				local opts = function(desc)
					return { noremap = true, silent = true, buffer = bufnr, desc = desc }
				end

				if not vim.b.lsp_hover_preview_set then
					vim.b.lsp_hover_preview_set = true
					vim.api.nvim_create_autocmd("CursorHold", {
						group = hover_group,
						buffer = bufnr,
						callback = function()
							if vim.fn.pumvisible() == 1 then
								return
							end
							vim.lsp.buf.hover()
						end,
					})
				end

				local has_telescope, telescope = pcall(require, "telescope.builtin")

				if has_telescope then
					vim.keymap.set("n", "gd", telescope.lsp_definitions, opts("Go to definition"))
					vim.keymap.set("n", "gi", telescope.lsp_implementations, opts("Implementation"))
					vim.keymap.set("n", "gr", telescope.lsp_references, opts("References"))
				else
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts("Go to definition"))
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts("Implementation"))
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts("References"))
				end

				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts("Go to declaration"))

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

			-- Bash
			vim.lsp.config("bashls", with_defaults({
				filetypes = { "sh", "bash", "zsh" },
				cmd       = { "bash-language-server", "start" },
				settings  = {
					bashIde = {
						globPattern = "*@(.sh|.bash|.zsh)",
					},
				},
			}))

			-- Python
			vim.lsp.config("pyright", with_defaults({
				settings = {
					python = {
						analysis = {
							typeCheckingMode       = "basic", -- can be: off, basic, strict
							autoImportCompletions  = true,
							autoSearchPaths        = true,
							diagnosticMode         = "workspace",
							useLibraryCodeForTypes = true,
							stubPath               = "typings",
						},
					},
				},
			}))

			-- Terraform
			vim.lsp.config("terraformls", with_defaults({
				filetypes = { "terraform", "tf", "terraform-vars" },
			}))
			-- C / C++
			vim.lsp.config("clangd", with_defaults({
				cmd = {
					"clangd",
					"--background-index",
					"--clang-tidy", -- enable Clang-Tidy lints
					"--header-insertion=iwyu", -- "include what you use"
					"--completion-style=detailed",
					"--suggest-missing-includes",
				},
				on_attach = function(client, bufnr)
					defaults.on_attach(client, bufnr)
					-- Disable default inline diagnostics if desired
					client.server_capabilities.semanticTokensProvider = nil
				end,
			}))
		end,
	},

	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		config = true,
	},
}

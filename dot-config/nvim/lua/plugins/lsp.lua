return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"SmiteshP/nvim-navic",
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
			local highlight_group = vim.api.nvim_create_augroup("LspDocumentHighlight", { clear = false })
			local has_navic, navic = pcall(require, "nvim-navic")
			if has_navic then
				navic.setup({
					highlight = false,
					separator = " > ",
				})
			end

			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
				border = "rounded",
				focusable = false,
				close_events = { "CursorMoved", "InsertEnter", "BufLeave" },
			})

			local on_attach = function(client, bufnr)
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
							local line = vim.api.nvim_win_get_cursor(0)[1] - 1
							if #vim.diagnostic.get(0, { lnum = line }) > 0 then
								return
							end
							vim.lsp.buf.hover()
						end,
					})
				end

				if client and client.server_capabilities.documentHighlightProvider and not vim.b.lsp_document_highlight_set then
					vim.b.lsp_document_highlight_set = true
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						group = highlight_group,
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.document_highlight()
						end,
					})
					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						group = highlight_group,
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.clear_references()
						end,
					})
				end

				if has_navic and client.server_capabilities.documentSymbolProvider then
					navic.attach(client, bufnr)
				end

				local function jump_to_highlight(direction)
					local params = vim.lsp.util.make_position_params()
					vim.lsp.buf_request_all(0, "textDocument/documentHighlight", params, function(responses)
						local highlights = {}
						for _, resp in pairs(responses) do
							if resp.result then
								for _, hl in ipairs(resp.result) do
									local start = hl.range.start
									table.insert(highlights, { start.line, start.character })
								end
							end
						end
						if #highlights == 0 then
							return
						end
						table.sort(highlights, function(a, b)
							if a[1] == b[1] then
								return a[2] < b[2]
							end
							return a[1] < b[1]
						end)

						local cur = vim.api.nvim_win_get_cursor(0)
						local cur_line = cur[1] - 1
						local cur_col = cur[2]
						local target

						if direction == "next" then
							for _, pos in ipairs(highlights) do
								if pos[1] > cur_line or (pos[1] == cur_line and pos[2] > cur_col) then
									target = pos
									break
								end
							end
							target = target or highlights[1]
						else
							for i = #highlights, 1, -1 do
								local pos = highlights[i]
								if pos[1] < cur_line or (pos[1] == cur_line and pos[2] < cur_col) then
									target = pos
									break
								end
							end
							target = target or highlights[#highlights]
						end

						vim.api.nvim_win_set_cursor(0, { target[1] + 1, target[2] })
					end)
				end

				vim.keymap.set("n", "gn", function()
					jump_to_highlight("next")
				end, opts("Next reference"))
				vim.keymap.set("n", "gN", function()
					jump_to_highlight("prev")
				end, opts("Prev reference"))

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

			-- Julia (mason's julia-lsp wrapper requires an explicit environment path)
			vim.lsp.config("julials", with_defaults({
				cmd = {
					"julia-lsp",
					vim.fn.expand("~/.julia/environments/nvim-lspconfig"),
				},
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

			-- Start servers (new API requires explicit enable)
			vim.lsp.enable({
				"lua_ls",
				"gopls",
				"pyright",
				"ts_ls",
				"clangd",
				"bashls",
				"julials",
				"terraformls",
			})
		end,
	},

	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		config = true,
	},
}

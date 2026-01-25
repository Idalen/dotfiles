-- General
vim.g.mapleader = " "

-- NeoTree
vim.api.nvim_create_user_command("Fx", function()
  vim.cmd("Neotree toggle")
end, {})

vim.api.nvim_create_user_command("Symbols", function()
  vim.cmd("Telescope lsp_document_symbols")
end, {})

vim.keymap.set("n", "<leader>e", ":Neotree<CR>")

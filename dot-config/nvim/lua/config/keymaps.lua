-- General
vim.g.mapleader = " "

-- NeoTree
vim.api.nvim_create_user_command("Fx", function()
  vim.cmd("Neotree toggle")
end, {})

vim.keymap.set("n", "<leader>e", ":Neotree<CR>")

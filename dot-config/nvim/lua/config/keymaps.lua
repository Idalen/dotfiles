-- copy relative path into pasteboard
vim.keymap.set("n", "<leader>ccp", function()
  local root = vim.fn.getcwd()
  local file = vim.fn.expand("%:p")
  local relative = vim.fn.fnamemodify(file, ":.")
  vim.fn.setreg("+", relative)
  print("Copied relative path: " .. relative)
end, { desc = "Copy relative file path from root" })

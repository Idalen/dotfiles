-- General
vim.g.mapleader = " "

local terminal_buf
local function toggle_terminal()
  if terminal_buf and vim.api.nvim_buf_is_valid(terminal_buf) then
    local win = vim.fn.bufwinid(terminal_buf)
    if win ~= -1 then
      vim.cmd("stopinsert")
      if #vim.api.nvim_list_wins() > 1 then
        vim.api.nvim_win_hide(win)
      else
        vim.cmd("enew")
      end
      return
    end
    vim.cmd("botright split")
    vim.api.nvim_win_set_buf(0, terminal_buf)
  else
    vim.cmd("botright split | terminal")
    terminal_buf = vim.api.nvim_get_current_buf()
    vim.bo[terminal_buf].bufhidden = "hide"
  end
  vim.cmd("startinsert")
end

vim.keymap.set("n", "<leader>T", toggle_terminal, { desc = "Toggle terminal" })
-- Keep Space free in terminal mode so typing does not wait for a leader mapping.
vim.keymap.set({ "n", "t" }, "<C-\\>", toggle_terminal, { desc = "Toggle terminal" })

-- Move lines in normal mode.
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==")
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==")

-- Move selections in visual mode.
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv")

-- Move between code, preview, and file explorer splits.
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window", silent = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window", silent = true })

-- NeoTree
vim.api.nvim_create_user_command("Fx", function()
  vim.cmd("Neotree toggle")
end, {})

vim.api.nvim_create_user_command("Symbols", function()
  vim.cmd("Telescope lsp_document_symbols")
end, {})

vim.keymap.set("n", "<leader>e", ":Neotree<CR>")

-- Copy the messages shown by the diagnostic float on the current line.
vim.api.nvim_create_user_command("CopyDiagnostic", function()
  local diagnostics = vim.diagnostic.get(0, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })
  if #diagnostics == 0 then
    vim.notify("No diagnostics on this line", vim.log.levels.INFO)
    return
  end

  local messages = {}
  for _, diagnostic in ipairs(diagnostics) do
    messages[#messages + 1] = diagnostic.message
  end
  local text = table.concat(messages, "\n\n")
  vim.fn.setreg('"', text)
  vim.fn.setreg("+", text)
  vim.notify("Copied diagnostics to clipboard")
end, { desc = "Copy current line diagnostics to clipboard" })

vim.keymap.set("n", "<leader>yd", "<cmd>CopyDiagnostic<CR>", { desc = "Copy diagnostics" })

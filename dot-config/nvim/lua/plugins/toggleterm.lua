return {
  "akinsho/toggleterm.nvim",
  lazy = false,
  priority = 1000,
  version = "*",
  event = "VeryLazy",
  opts = {
    size = 20,
    open_mapping = [[<C-\>]],
    hide_numbers = true,
    shade_filetypes = {},
    shade_terminals = true,
    shading_factor = 2,
    start_in_insert = true,
    insert_mappings = true,
    terminal_mappings = true,
    persist_size = true,
    persist_mode = true,
    direction = "float", -- or 'horizontal' | 'vertical' | 'tab'
    close_on_exit = true,
    shell = vim.o.shell,
    float_opts = {
      border = "curved",
      winblend = 0,
    },
  },
  config = function(_, opts)
    require("toggleterm").setup(opts)

    -- Optional: Keymaps for easier terminal management
    local Terminal = require("toggleterm.terminal").Terminal

    local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })
    function _LAZYGIT_TOGGLE()
      lazygit:toggle()
    end

    vim.keymap.set("n", "<leader>tg", _LAZYGIT_TOGGLE, { desc = "Toggle Lazygit" })
    vim.keymap.set({ "n", "t" }, "<C-\\>", "<cmd>ToggleTerm<CR>", { desc = "Toggle Terminal" })
  end,
}

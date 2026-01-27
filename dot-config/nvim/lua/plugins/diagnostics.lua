return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    focus = true,
    keys = {
      ["<cr>"] = "jump_close",
    },
    modes = {
      diagnostics = {
        win = {
          type = "float",
          relative = "editor",
          border = "rounded",
          position = "center",
          size = { width = 0.8, height = 0.7 },
        },
        preview = {
          type = "split",
          relative = "win",
          position = "right",
          size = 0.4,
        },
      },
      symbols = {
        win = {
          type = "split",
          relative = "editor",
          position = "right",
          size = 0.5,
        },
      },
    },
  },
  keys = {
    {
      "<leader>xx",
      "<cmd>Telescope diagnostics line_width=full<cr>",
      desc = "Diagnostics (workspace, preview)",
    },
    {
      "<leader>xX",
      "<cmd>Telescope diagnostics bufnr=0 line_width=full<cr>",
      desc = "Diagnostics (current file, preview)",
    },
    {
      "<leader>s",
      "<cmd>Trouble symbols toggle focus=true<cr>",
      desc = "Document Symbols",
    },
    {
      "<leader>xl",
      "<cmd>Trouble lsp toggle<cr>",
      desc = "LSP Definitions/References/etc",
    },
  },
}

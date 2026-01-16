return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    focus = true,
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
      "<leader>xs",
      "<cmd>Trouble symbols toggle<cr>",
      desc = "Document Symbols",
    },
    {
      "<leader>xl",
      "<cmd>Trouble lsp toggle<cr>",
      desc = "LSP Definitions/References/etc",
    },
  },
}

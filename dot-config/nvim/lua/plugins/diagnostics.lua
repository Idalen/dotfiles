return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    modes = {
      diagnostics = {
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
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "Diagnostics (workspace)",
    },
    {
      "<leader>xX",
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      desc = "Diagnostics (current file)",
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

return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = "nvim-tree/nvim-web-devicons",
  event = "VeryLazy",
  config = function()
    vim.opt.termguicolors = true

    require("bufferline").setup({
      options = {
        mode = "buffers",         -- or "tabs"
        numbers = "none",         -- "ordinal" | "buffer_id" | "both" | function
        diagnostics = "nvim_lsp", -- show LSP diagnostics in the tabline
        diagnostics_update_in_insert = false,

        --- Neo-tree integration: create a clean offset on the left
        offsets = {
          {
            filetype = "neo-tree",
            text = "File Explorer",
            highlight = "Directory",
            text_align = "left",
            separator = true,
          },
        },

        show_buffer_close_icons = false,
        show_close_icon = false,
        always_show_bufferline = true,
        separator_style = "thin", -- "slant" | "thick" | "thin" | { 'any', 'any' }

        -- how to pick buffers when using :BufferLinePick
        hover = {
          enabled = true,
          delay = 200,
          reveal = { "close" },
        },
      },
    })

    -- === Keymaps ===
    local map = vim.keymap.set

    -- Cycle through buffers (like switching tabs)
    map("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
    map("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Prev buffer" })

    -- Reorder buffers
    map("n", "<A-l>", "<cmd>BufferLineMoveNext<CR>", { desc = "Move buffer right" })
    map("n", "<A-h>", "<cmd>BufferLineMovePrev<CR>", { desc = "Move buffer left" })

    -- Close current buffer
    map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })

    -- Pick a buffer by letter
    map("n", "<leader>bb", "<cmd>BufferLinePick<CR>", { desc = "Pick buffer" })

    -- Close others / right / left
    map("n", "<leader>bo", "<cmd>BufferLineCloseOthers<CR>", { desc = "Close other buffers" })
    map("n", "<leader>br", "<cmd>BufferLineCloseRight<CR>", { desc = "Close buffers to the right" })
    map("n", "<leader>bl", "<cmd>BufferLineCloseLeft<CR>", { desc = "Close buffers to the left" })
  end,
}

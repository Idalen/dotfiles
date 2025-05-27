return {
  { "ellisonleao/gruvbox.nvim" },
  {
    "rebelot/kanagawa.nvim",
    lazy = false, -- Load during startup
    priority = 1000, -- Load before other plugins
    config = function()
      require("kanagawa").setup({
        -- Optional: customize settings here
      })
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kanagawa",
    },
  },
}

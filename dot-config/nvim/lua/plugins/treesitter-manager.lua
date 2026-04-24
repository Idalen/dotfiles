return {
  {
    "romus204/tree-sitter-manager.nvim",
    dependencies = {}, -- tree-sitter CLI must be installed system-wide
    config = function()
      require("tree-sitter-manager").setup({
        ensure_installed = {
          "rust",
          "lua",
          "go",
          "python",
          "javascript",
          "typescript",
          "c",
          "cpp",
          "bash",
          "terraform",
          "julia",
          "html",
        },
        auto_install = true,
        highlight = true,
      })
    end,
  },
}
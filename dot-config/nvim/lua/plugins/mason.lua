return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- Lua
        "lua-language-server",
        "stylua",

        -- Shell
        "shellcheck",
        "shfmt",
        "bash-language-server",

        -- Python
        "flake8",
        "pyright",

        -- Go
        "gopls",
        "golines", -- formatter
        "goimports", -- formatter/fixer
        "gofumpt", -- formatter
        "revive", -- linter

        -- C/C++
        "clangd", -- LSP
        "clang-format", -- formatter
        "cpplint", -- linter

        -- Optional: general purpose
        "codespell", -- typo checker
      },
    },
  },
}

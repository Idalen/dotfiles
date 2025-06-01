return {
  "stevearc/conform.nvim",
  opts = {
    format_on_save = {
      lsp_fallback = true,
      timeout_ms = 1000,
    },
    formatters_by_ft = {
      go = { "goimports", "gofmt" },
      lua = { "stylua" },
      sh = { "shfmt" },
      bash = { "shfmt" },
      zsh = { "shfmt" },
    },
  },
}

return {
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        -- Go
        gopls = {},

        -- Lua
        lua_ls = {
          settings = {
            Lua = {
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
              diagnostics = {
                globals = { "vim" }, -- Avoid "undefined global vim" warning
              },
            },
          },
        },

        -- C++
        clangd = {},
      },

      --- Optional: Additional server-specific setup
      setup = {
        gopls = function(_, opts)
          -- Optional custom setup for gopls
          return false -- return false to proceed with default setup
        end,
        lua_ls = function(_, opts)
          -- Optional custom setup for lua_ls
          return false
        end,
        clangd = function(_, opts)
          -- Optional custom setup for clangd
          return false
        end,
      },
    },
  },
}

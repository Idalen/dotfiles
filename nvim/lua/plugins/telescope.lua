return {
  "nvim-telescope/telescope.nvim",
  keys = {
    -- Browse plugin files (Lazy root)
    {
      "<leader>fp",
      function()
        require("telescope.builtin").find_files({
          cwd = require("lazy.core.config").options.root,
          hidden = true,
        })
      end,
      desc = "Find Plugin File (Lazy Root)",
    },

    -- Find files from current working directory (including hidden files)
    {
      "<leader>ff",
      function()
        require("telescope.builtin").find_files({
          cwd = vim.fn.getcwd(),
          hidden = true,
        })
      end,
      desc = "[F]ind [F]iles (CWD, hidden)",
    },

    -- Live grep from current working directory (including hidden files)
    {
      "<leader>fG",
      function()
        require("telescope.builtin").live_grep({
          cwd = vim.fn.getcwd(),
          additional_args = { "--hidden" },
        })
      end,
      desc = "[F]ind [G]rep in Files (CWD, hidden)",
    },
  },

  -- Add the :FHome command
  config = function(_, opts)
    local telescope = require("telescope")
    telescope.setup(opts)

    vim.api.nvim_create_user_command("FHome", function()
      require("telescope.builtin").find_files({
        cwd = vim.fn.expand("~"),
        hidden = true,
      })
    end, { desc = "Find Files from Home (~)" })


  end,

  opts = {
    defaults = {
      layout_strategy = "horizontal",
      layout_config = { prompt_position = "top" },
      sorting_strategy = "ascending",
      winblend = 0,
    },
    {
pickers = {
        find_files = {
          hidden=true
        }
      }
    },
  },
}


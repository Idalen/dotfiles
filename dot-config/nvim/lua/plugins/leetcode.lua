return {
  "kawre/leetcode.nvim",
  build = ":TSUpdate html",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    -- picker: telescope is already installed
  },
  opts = {
    lang = "go",
    picker = {
      provider = "telescope",
    },
    storage = {
      home = vim.fn.stdpath("data") .. "/leetcode",
      cache = vim.fn.stdpath("cache") .. "/leetcode",
    },
    logging = true,
    console = {
      open_on_runcode = true,
      dir = "row",
      size = {
        width = "90%",
        height = "75%",
      },
      result = {
        size = "60%",
      },
      testcase = {
        virt_text = true,
        size = "40%",
      },
    },
    description = {
      position = "left",
      width = "40%",
      show_stats = true,
    },
    keys = {
      toggle = { "q" },
      confirm = { "<CR>" },
      reset_testcases = "r",
      use_testcase = "U",
      focus_testcases = "H",
      focus_result = "L",
    },
  },
  config = function(_, opts)
    require("leetcode").setup(opts)
    -- Keymaps
    vim.keymap.set("n", "<leader>Ll", "<cmd>Leet<CR>", { desc = "Open LeetCode" })
    vim.keymap.set("n", "<leader>Lr", "<cmd>Leet run<CR>", { desc = "Run test cases" })
    vim.keymap.set("n", "<leader>Ls", "<cmd>Leet submit<CR>", { desc = "Submit solution" })
    vim.keymap.set("n", "<leader>LR", "<cmd>Leet reset<CR>", { desc = "Reset test cases" })
  end,
}
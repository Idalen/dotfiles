return {
  {
    "ojroques/nvim-osc52",
    config = function()
      local osc52 = require("osc52")

      osc52.setup({
        max_length = 0,
        silent = false,
        trim = false,
      })

      local function copy()
        if vim.v.event.operator == "y" and vim.v.event.regname == "" then
          osc52.copy_register("")
        end
      end

      vim.api.nvim_create_autocmd("TextYankPost", { callback = copy })
    end,
  },
}

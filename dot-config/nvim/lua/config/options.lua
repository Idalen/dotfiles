vim.g.lazyvim_check_order = false
vim.opt.clipboard = "unnamedplus"

vim.opt.autoread = true

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.o.termguicolors = true
vim.opt.scrolloff = 12
vim.opt.updatetime = 250

vim.diagnostic.config({
	virtual_text = {
		spacing = 2,
		prefix = "●",
	},
	severity_sort = true,
})

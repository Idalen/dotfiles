return {
	"lervag/vimtex",
	-- VimTeX handles filetype loading itself; inverse search needs its global command.
	lazy = false,
	init = function()
		vim.g.tex_flavor = "latex"
		vim.g.vimtex_compiler_method = "latexmk"
		vim.g.vimtex_view_method = "zathura"
		vim.g.vimtex_view_automatic = 0
		vim.g.vimtex_quickfix_mode = 0
		vim.api.nvim_create_user_command("Tc", "VimtexCompile!", {
			desc = "Start continuous LaTeX compilation",
			force = false,
		})
		vim.api.nvim_create_user_command("Tv", function()
			local preview = require("config.latex-preview")
			if preview.close() then
				return
			end
			if not vim.b.vimtex then
				vim.notify("Run :Tv from a LaTeX buffer.", vim.log.levels.WARN)
				return
			end
			local pdf = vim.fn.eval("b:vimtex.compiler.get_file('pdf')")
			if pdf ~= "" and preview.close(pdf) then
				return
			end
			vim.cmd("VimtexCompile!")
			if pdf == "" or vim.fn.filereadable(pdf) == 0 then
				vim.notify("PDF not found yet. Wait for compilation, then run :Tv again.", vim.log.levels.WARN)
				return
			end
			-- Keep the display separate from the file so :checktime cannot reload
			-- it through Snacks' default PDF handler and restore a cached image.
			vim.cmd("botright vnew")
			local buf = vim.api.nvim_get_current_buf()
			vim.bo[buf].buftype = "nofile"
			vim.bo[buf].bufhidden = "wipe"
			vim.bo[buf].buflisted = false
			vim.bo[buf].swapfile = false
			vim.bo[buf].modifiable = false
			vim.api.nvim_buf_set_name(buf, "LaTeX preview [" .. buf .. "]")
			preview.attach(buf, pdf)
			preview.watch(buf)
		end, {
			desc = "Toggle LaTeX PDF preview",
			force = false,
		})
	end,
}

local group = vim.api.nvim_create_augroup("StartupCleanup", { clear = true })
local diag_group = vim.api.nvim_create_augroup("DiagnosticsHover", { clear = true })

local function is_empty_unnamed_buffer(buf)
	if vim.api.nvim_buf_get_name(buf) ~= "" then
		return false
	end
	if vim.bo[buf].buftype ~= "" then
		return false
	end
	if vim.api.nvim_buf_line_count(buf) ~= 1 then
		return false
	end
	return vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] == ""
end

local function cleanup_empty_buffers()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(buf) and is_empty_unnamed_buffer(buf) then
			vim.api.nvim_buf_delete(buf, { force = true })
		end
	end
end

vim.api.nvim_create_autocmd("VimEnter", {
	group = group,
	callback = function()
		local arg = vim.fn.argv(0)
		if vim.fn.argc() == 1 and vim.fn.isdirectory(arg) == 1 then
			vim.schedule(cleanup_empty_buffers)
		end
	end,
})

vim.api.nvim_create_autocmd("CursorHold", {
	group = diag_group,
	callback = function()
		vim.diagnostic.open_float(nil, {
			focusable = false,
			close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
			border = "rounded",
			source = "if_many",
			scope = "cursor",
		})
	end,
})

vim.api.nvim_create_autocmd(
  { "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" },
  {
    command = "checktime",
  }
)

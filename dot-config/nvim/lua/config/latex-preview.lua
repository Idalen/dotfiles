local M = {}
local previews = {}
local uv = vim.uv
local group = vim.api.nvim_create_augroup("LatexPdfPreview", { clear = true })

local function layout(buf, state)
	if previews[buf] ~= state or not vim.api.nvim_buf_is_loaded(buf) or not state.pages then
		return
	end
	local wins = vim.fn.win_findbuf(buf)
	if #wins == 0 then
		return
	end
	local views, width = {}, vim.o.columns
	for _, win in ipairs(wins) do
		views[win] = vim.api.nvim_win_call(win, vim.fn.winsaveview)
		for name, value in pairs(Snacks.image.config.wo) do
			vim.wo[win][name] = value
		end
		vim.wo[win].scrolloff = 0
		width = math.min(width, vim.api.nvim_win_get_width(win))
	end
	local row = 1
	for _, page in ipairs(state.pages) do
		local size = Snacks.image.util.fit(page.file, { width = width, height = 10000 })
		page.row, page.height = row, size.height
		row = row + size.height + 2
	end
	local count, height = vim.api.nvim_buf_line_count(buf), row - 3
	vim.bo[buf].modifiable = true
	if count < height then
		local lines = {}
		for _ = count + 1, height do
			lines[#lines + 1] = ""
		end
		vim.api.nvim_buf_set_lines(buf, count, -1, false, lines)
	elseif count > height then
		vim.api.nvim_buf_set_lines(buf, height, -1, false, {})
	end
	vim.bo[buf].modified = false
	vim.bo[buf].modifiable = false
	for _, page in ipairs(state.pages) do
		local opts = {
			inline = true, conceal = true,
			width = width, height = 10000,
			pos = { page.row, 0 },
			range = { page.row, 0, page.row + page.height - 1, 0 },
		}
		if page.placement then
			page.placement.opts = opts
			page.placement:update()
		else
			page.placement = Snacks.image.placement.new(buf, page.file, opts)
		end
	end
	for win, view in pairs(views) do
		vim.api.nvim_win_call(win, function()
			vim.fn.winrestview(view)
		end)
	end
end

local render
render = function(buf, state)
	if previews[buf] ~= state or not vim.api.nvim_buf_is_loaded(buf) then
		return
	end
	if state.process or #vim.fn.win_findbuf(buf) == 0 then
		return
	end
	state.dirty = false
	local dir = vim.fn.tempname()
	vim.fn.mkdir(dir, "p")
	-- A fresh directory avoids stale image caches and keeps full page margins.
	state.process = vim.system({
		"pdftoppm", "-png", "-scale-to-x", "1600", "-scale-to-y", "-1",
		state.pdf, dir .. "/page",
	}, { text = true }, vim.schedule_wrap(function(result)
		state.process = nil
		if previews[buf] ~= state or not vim.api.nvim_buf_is_loaded(buf) then
			vim.fn.delete(dir, "rf")
			return
		end
		local files = vim.fn.glob(dir .. "/page-*.png", false, true)
		table.sort(files, function(a, b)
			return tonumber(a:match("page%-(%d+)%.png$")) < tonumber(b:match("page%-(%d+)%.png$"))
		end)
		if result.code ~= 0 or #files == 0 then
			vim.fn.delete(dir, "rf")
			vim.notify("PDF preview failed: " .. (result.stderr or "no pages rendered"), vim.log.levels.WARN)
		else
			Snacks.image.placement.clean(buf)
			if state.dir then
				vim.fn.delete(state.dir, "rf")
			end
			state.dir, state.pages = dir, {}
			for _, file in ipairs(files) do
				state.pages[#state.pages + 1] = { file = file }
			end
			vim.b[buf].latex_preview_pages = #files
			layout(buf, state)
		end
		if state.dirty then
			render(buf, state)
		end
	end))
end

local function stop(buf)
	local state = previews[buf]
	if not state then
		return
	end
	previews[buf] = nil
	for _, handle in ipairs({ state.poll, state.timer }) do
		handle:stop()
		handle:close()
	end
	if state.process then
		state.process:kill(15)
	end
	Snacks.image.placement.clean(buf)
	if state.dir then
		vim.fn.delete(state.dir, "rf")
	end
end

-- With no path, close only if the current buffer is itself a preview.
function M.close(pdf)
	local current = vim.api.nvim_get_current_buf()
	local matches = {}
	for buf, state in pairs(previews) do
		if (pdf and state.pdf == pdf) or (not pdf and buf == current) then
			matches[#matches + 1] = buf
		end
	end
	for _, buf in ipairs(matches) do
		for _, win in ipairs(vim.fn.win_findbuf(buf)) do
			if #vim.api.nvim_list_wins() > 1 then
				vim.api.nvim_win_close(win, true)
			end
		end
		if vim.api.nvim_buf_is_valid(buf) then
			vim.api.nvim_buf_delete(buf, { force = true })
		end
	end
	return #matches > 0
end

function M.attach(buf, pdf)
	stop(buf)
	if vim.fn.executable("pdftoppm") == 0 then
		vim.notify("PDF preview requires pdftoppm (install poppler-utils).", vim.log.levels.ERROR)
		return
	end
	local state = { pdf = pdf, poll = assert(uv.new_fs_poll()), timer = assert(uv.new_timer()), dirty = true }
	previews[buf] = state
	Snacks.image.terminal.detect(function()
		if previews[buf] ~= state then
			return
		end
		if not Snacks.image.terminal.env().placeholders then
			vim.notify("Scrollable PDF preview requires Ghostty or Kitty graphics support.", vim.log.levels.ERROR)
			stop(buf)
			return
		end
		Snacks.image.placement.clean(buf)
		vim.bo[buf].filetype = "image"
		vim.bo[buf].swapfile = false
		render(buf, state)
	end)
end

function M.watch(buf)
	local state = previews[buf]
	if not state then
		return
	end
	local ok, err = state.poll:start(state.pdf, 500, function(poll_err)
		if poll_err or previews[buf] ~= state then
			return
		end
		state.dirty = true
		state.timer:start(500, 0, vim.schedule_wrap(function()
			render(buf, state)
		end))
	end)
	if not ok then
		vim.notify("Unable to watch PDF: " .. tostring(err), vim.log.levels.ERROR)
	end
end

vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter", "WinResized" }, {
	group = group,
	callback = function()
		vim.schedule(function()
			for buf, state in pairs(previews) do
				layout(buf, state)
				if state.dirty then
					render(buf, state)
				end
			end
		end)
	end,
})

vim.api.nvim_create_autocmd({ "BufUnload", "BufWipeout" }, {
	group = group,
	callback = function(event)
		stop(event.buf)
	end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
	group = group,
	callback = function()
		for buf in pairs(previews) do
			stop(buf)
		end
	end,
})

return M

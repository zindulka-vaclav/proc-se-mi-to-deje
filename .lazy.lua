local function apply_prose_options(buf, win)
	local bo = vim.opt
	local wo = vim.opt

	if buf then
		if not vim.api.nvim_buf_is_valid(buf) or vim.bo[buf].buftype ~= "" then
			return
		end
		bo = vim.bo[buf]
		wo = (win and vim.api.nvim_win_is_valid(win)) and vim.wo[win] or nil
	end

	bo.spelllang = "cs"
	bo.textwidth = 0
	bo.wrapmargin = 0

	if wo then
		wo.spell = true
		wo.wrap = true
		wo.showbreak = "->"
	end
end

-- 1. Set global defaults (called with no arguments)
apply_prose_options()

local group = vim.api.nvim_create_augroup("ProjectProseOptions", { clear = true })

-- 2. Apply to windows/buffers already open at startup
vim.api.nvim_create_autocmd("User", {
	group = group,
	pattern = "VeryLazy",
	once = true,
	callback = function()
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			apply_prose_options(vim.api.nvim_win_get_buf(win), win)
		end
		vim.notify("Set spell checking to cs in .lazy.lua")
	end,
})

-- 3. Apply whenever a buffer is displayed in a window
vim.api.nvim_create_autocmd("BufWinEnter", {
	group = group,
	callback = function(ev)
		apply_prose_options(ev.buf, vim.api.nvim_get_current_win())
	end,
})

return {}

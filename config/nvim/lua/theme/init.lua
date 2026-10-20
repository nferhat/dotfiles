-- NOTE: no bytecode cache anymore, highlights are applied on every start. It's
-- a few hundred nvim_set_hl calls, not worth the cache invalidation headache.
local M = {}

-- Drop every theme module so the next require re-reads them from disk
local function reload_modules()
	for name in pairs(package.loaded) do
		if name:find '^theme%.' then package.loaded[name] = nil end
	end
end

local function apply(highlights)
	for group, opts in pairs(highlights) do
		-- A bare Color means fg only
		if opts.HEX then opts = { fg = opts } end

		local hl = {}
		for k, v in pairs(opts) do
			hl[k] = type(v) == 'table' and v.HEX and v:HEX(true) or v
		end
		vim.api.nvim_set_hl(0, group, hl)
	end
end

function M.init()
	apply(require 'theme.highlights')

	-- Set terminal colors too
	local colors = require 'theme.colors'
	for i = 0, 15 do
		local hex = colors['color' .. i]:HEX(true)
		vim.g['terminal_color_' .. i] = hex
		vim.api.nvim_set_hl(0, 'Terminal' .. i, { fg = hex })
	end
end

vim.api.nvim_create_user_command('ReloadTheme', function(args)
	for _, flag in ipairs(vim.split(args.args, '%s')) do
		if flag == 'cmp-kinds-bg-on' then
			vim.g.cmp_with_bg = true
		elseif flag == 'cmp-kinds-bg-off' then
			vim.g.cmp_with_bg = false
		end
	end

	reload_modules()
	-- Sources colors/theme.lua, which calls M.init again with the fresh modules
	vim.cmd.colorscheme 'theme'
end, {
	nargs = '*',
	complete = function() return { 'cmp-kinds-bg-on', 'cmp-kinds-bg-off' } end,
})

return M

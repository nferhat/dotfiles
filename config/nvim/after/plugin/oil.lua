-- oil.nvim -*- trying it out
-- looks pretty interesting and also well polished
vim.pack.add { 'https://github.com/stevearc/oil.nvim' }

-- Custom owner column, using uv in order to get the info
local me = assert(vim.uv.os_get_passwd())
local FIELD_META = require('oil.constants').FIELD_META
require('oil.columns').register('owner', {
	render = function(entry)
		local stat = entry[FIELD_META] and entry[FIELD_META].stat
		if not stat then return nil end
		-- XXX: luv can only resolve *our* uid, others just show the number
		return stat.uid == me.uid and me.username or tostring(stat.uid)
	end,
	parse = function(line) return line:match '^(%S+)%s+(.*)$' end,
})

-- Set up the highlights for the custom permissions column
for kind, n in pairs { Read = 3, Write = 1, Exec = 2 } do
	local fg = vim.g['terminal_color_' .. n]
	vim.api.nvim_set_hl(0, 'OilPerm' .. kind, { fg = fg })
	vim.api.nvim_set_hl(0, 'OilPerm' .. kind .. 'Own', { fg = fg, bold = true })
end
vim.api.nvim_set_hl(
	0,
	'OilPermExecOwnFile',
	{ fg = vim.g.terminal_color_2, bold = true, underline = true }
)
vim.api.nvim_set_hl(0, 'OilPermNone', { link = 'Comment' })

-- oil only gives one hl per column via `highlight`, but render can return
-- per-char ranges, so wrap the files adapter one in-place (keeps chmod-on-save)
local perms = require('oil.adapters.files').get_column 'permissions'
local render_perms = perms.render
local perm_kind =
	{ r = 'Read', w = 'Write', x = 'Exec', s = 'Exec', S = 'Exec', t = 'Exec', T = 'Exec' }
perms.render = function(entry, ...)
	local text = render_perms(entry, ...)
	if type(text) ~= 'string' then return text end
	local hls = {}
	for i = 1, #text do
		local kind = perm_kind[text:sub(i, i)]
		local hl = 'OilPermNone'
		if kind then
			hl = 'OilPerm' .. kind .. (i <= 3 and 'Own' or '')
			if hl == 'OilPermExecOwn' and entry[3] == 'file' then hl = hl .. 'File' end -- FIELD_TYPE
		end
		hls[i] = { hl, i - 1, i }
	end
	return { text, hls }
end

-- oil sizes a column by its widest value and has no min width, so pad the
-- size text to 6 chars. Size is read-only, so nothing parses it back
local size = require('oil.adapters.files').get_column 'size'
local render_size = size.render
size.render = function(entry, ...)
	local text = render_size(entry, ...)
	if type(text) ~= 'string' then return text end
	return (' '):rep(6 - #text) .. text
end

require('oil').setup {
	columns = {
		-- dired-like view
		'permissions',
		{ 'size', highlight = 'String', align = 'right' },
		{ 'owner', highlight = 'Constant' },
		{ 'mtime', highlight = 'Directory', format = '%e %b %H:%M' },
		'icon',
	},
	win_options = { nu = false, rnu = false, colorcolumn = '' },
	delete_to_trash = true,
	skip_confirm_for_simple_edits = true,

	-- The default keymaps are kinda weird, like why - for going to parent???
	keymaps = {
		-- quit nvim when oil is the last buffer left
		['q'] = { 'actions.close', opts = { exit_if_last_buf = true }, mode = 'n' },
		['<C-c>'] = { 'actions.close', opts = { exit_if_last_buf = true } },
		['<BS>'] = 'actions.parent',
		['-'] = { 'actions.cd', mode = 'n' },
		['g~'] = { 'actions.cd', opts = { scope = 'tab' }, mode = 'n' },
	},

	view_options = { show_hidden = true },

	-- Golden ratio sized, centered float. oil centers it already, border is 1 col
	float = {
		padding = 2,
		max_width = 0.618,
		max_height = 0.618,
		border = 'single',
		get_win_title = function() return '' end, -- no title, just the border
	},
}

-- NOTE: new lines have no columns so they start at col 0, ugly. pad them with
-- inline virt text up to where the names start
local pad_ns = vim.api.nvim_create_namespace 'oil_pad'

local function draw_padding(buf)
	vim.api.nvim_buf_clear_namespace(buf, pad_ns, 0, -1)
	local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
	local new = {}
	for i, line in ipairs(lines) do
		if not line:match '^/%d+' then new[#new + 1] = i end
	end
	if #new == 0 then return end

	local view, cache, util = require 'oil.view', require 'oil.cache', require 'oil.util'
	local adapter = util.get_adapter(buf, true)
	if not adapter then return end
	local defs = require('oil.columns').get_supported_columns(adapter)
	-- measure the real rows like oil does, padding = column widths + separators
	local width = {}
	for i = 2, #defs + 1 do
		width[i] = 1
	end
	for _, line in ipairs(lines) do
		local entry = cache.get_entry_by_id(tonumber(line:match '^/(%d+)') or 0)
		if entry then view.format_entry_cols(entry, defs, width, adapter, false, buf) end
	end
	local pad = #defs
	for i = 2, #defs + 1 do
		pad = pad + width[i]
	end

	for _, i in ipairs(new) do
		vim.api.nvim_buf_set_extmark(buf, pad_ns, i - 1, 0, {
			virt_text = { { string.rep(' ', pad) } },
			virt_text_pos = 'inline',
			right_gravity = false, -- typed text goes after the padding, not before
		})
	end
end

vim.api.nvim_create_autocmd('FileType', {
	pattern = 'oil',
	callback = function(ev)
		vim.api.nvim_create_autocmd({ 'TextChanged', 'TextChangedI' }, {
			buffer = ev.buf,
			callback = function() draw_padding(ev.buf) end,
		})
	end,
})

vim.keymap.set(
	'n',
	'<leader><leader>',
	function() require('oil').open_float() end,
	{ desc = 'Open parent directory' }
)

-- snacks.lua -*- the master plugin
--
-- provides pickers & more, makes my life easier since it's not telescope + plugins + other
-- stuff and it gets annoying managing a bunch of stuff, this just has "everything"

vim.pack.add { 'https://github.com/folke/snacks.nvim' }

require('snacks').setup {
	quickfile = {}, -- Simple yet really useful
	input = { win = { border = 'single' } },
	-- No need for these.
	dashboard = { enabled = false },

	-- Quick styling since this configuration has a "blocky" look/feel, with border=single
	styles = {
		-- Why is it mapped to normal by default!?
		scratch = { wo = { winhighlight = 'NormalFloat:NormalFloat' }, border = 'single' },
		-- Make the input slightly smaller, and slightly lower on the screen
		input = { border = 'single', row = 0.35, width = 40 },
		-- Make the zen window slightly larger
		zen = {
			enter = true,
			fixbuf = false,
			minimal = false,
			width = 160,
			height = 0,
			backdrop = { transparent = true, blend = 40 },
			keys = { q = false },
			zindex = 40,
			wo = { winhighlight = 'NormalFloat:Normal' },
			w = { snacks_main = true },
		},
	},

	-- Quick scratch buffer, useful todo quick reasoning/thinking
	-- I mostly need it to write stuff with bullet points/whatnot
	scratch = { ft = 'markdown' },

	-- Better ordering, nothing special though.
	statuscolumn = {
		left = { 'mark', 'sign' },
		right = { 'fold', 'git' },
		folds = { open = false, git_hl = true },
		git = { patterns = { 'GitSign' } },
		refresh = 50, -- refresh at most every 100ms
	},

	-- Replaces indent-blankline.nvim
	indent = { char = '▎', scope = { underline = true } },

	-- A picker that I find more useful (and kinda cooler) than telescope.nvim
	-- 1. No dependency on external plugin for correct fuzzy matching
	-- 2. Better ivy theme than telescope
	-- 3. Replace default neovim UI handlers. Much better than using the keyboard.
	picker = {
		prompt = '', -- no little ">" before the search text
		auto_close = true,
		icons = { files = { enabled = false } },
		layouts = {
			-- Enable borders for the default picker.
			default = {
				layout = {
					box = 'horizontal',
					width = 0.6,
					min_width = 120,
					height = 0.6,
					border = 'none',
					{
						box = 'vertical',
						title = '{title} {live} {flags}',
						border = 'single',
						{ win = 'input', height = 1, border = 'bottom' },
						{ win = 'list', border = 'none' },
					},
					{ win = 'preview', border = 'single', width = 0.6, minimal = true },
				},
			},
			select = {
				layout = {
					box = 'horizontal',
					width = 0.8,
					min_width = 120,
					height = 0.8,
					border = 'none',
					{
						box = 'vertical',
						title = '{title} {live} {flags}',
						border = 'single',
						{ win = 'input', height = 1, border = 'bottom' },
						{ win = 'list', border = 'none' },
					},
					{ win = 'preview', border = 'single', width = 0.6, minimal = true },
				},
			},
			-- Variation of default picker with a smaller window size and larger preview window
			-- I mostly care about what im about to jump to when im inside the buffer picker
			buffers = {
				layout = {
					box = 'horizontal',
					width = 0.3,
					min_width = 120,
					height = 0.4,
					{ win = 'list', border = 'single' },
					{ win = 'preview', border = 'single', width = 0.65, minimal = true },
				},
			},
			-- Make select smaller
			select = {
				hidden = { 'preview' },
				layout = {
					backdrop = false,
					width = 0.3,
					min_width = 35,
					height = 0.4,
					min_height = 3,
					box = 'vertical',
					border = true,
					title = '{title}',
					title_pos = 'center',
					{ win = 'input', height = 1, border = 'bottom' },
					{ win = 'list', border = 'none' },
					{ win = 'preview', title = '{preview}', height = 0.4, border = 'top' },
				},
			},
		},

		sources = {
			buffers = { layout = 'buffers' },
			recent = {
				layout = {
					preset = 'default',
					layout = { width = 0.5, height = 0.6 },
				},
			},
		},
	},
}

-- Top Pickers & Explorer
Snacks = Snacks
vim.keymap.set('n', '<leader>f', function() Snacks.picker.files() end, { desc = 'Find Files' })
vim.keymap.set('n', '<leader>m', function() Snacks.picker.man() end, { desc = 'Find Manpage' })
vim.keymap.set('n', '<leader>?', function() Snacks.picker.help() end, { desc = 'Find Help' })
vim.keymap.set('n', '<leader>b', function() Snacks.picker.buffers() end, { desc = 'Buffers' })
vim.keymap.set('n', '<leader>/', function() Snacks.picker.grep() end, { desc = 'Grep' })
vim.keymap.set(
	'n',
	'<leader>D',
	function() Snacks.picker.diagnostics() end,
	{ desc = 'Workspace Diagnostics' }
)
vim.keymap.set('n', '<leader>o', function() Snacks.picker.recent() end, { desc = 'Recent' })

-- Git
vim.keymap.set('n', '<leader>gl', function() Snacks.picker.git_log() end, { desc = 'Log' })
vim.keymap.set(
	'n',
	'<leader>gL',
	function() Snacks.picker.git_log_line() end,
	{ desc = 'Log Line' }
)
vim.keymap.set('n', '<leader>gs', function() Snacks.picker.git_status() end, { desc = 'Status' })
vim.keymap.set('n', '<leader>gS', function() Snacks.picker.git_stash() end, { desc = 'Stash' })
vim.keymap.set(
	'n',
	'<leader>gd',
	function() Snacks.picker.git_diff() end,
	{ desc = 'Diff (Hunks)' }
)
vim.keymap.set(
	'n',
	'<leader>gf',
	function() Snacks.picker.git_log_file() end,
	{ desc = 'Log File' }
)

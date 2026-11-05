-- mini.nvim -*- the other uber plugin
-- Contains cool stuff, self-contained modules...

vim.pack.add {
	'https://github.com/nvim-mini/mini-git',
	'https://github.com/nvim-mini/mini.clue',
	'https://github.com/nvim-mini/mini.align',
	'https://github.com/nvim-mini/mini.pairs',
}

local map = vim.keymap.set

-- Git "integration": being able to use git without having to switch tmux panes is amazing
-- <leader>G autocompletes ':Git ' in the commandline,then I just add commit or whtv
do
	require('mini.git').setup()
	map('n', '<leader>G', ':Git ', { desc = 'Git' })
end

-- Nice plugin works like mini.align
-- Nothing much to say
require('mini.align').setup()

do
	-- Very nice, and I like it
	local miniclue = require 'mini.clue'
	miniclue.setup {
		window = {
			config = {
				border = 'single',
				style = 'minimal',
				width = 'auto',
			},
			delay = 0,
		},
		triggers = {
			-- Leader triggers
			{ mode = { 'n', 'x' }, keys = '<Leader>' },
			-- `g` key
			{ mode = { 'n', 'x' }, keys = 'g' },
			-- Registers
			{ mode = { 'n', 'x' }, keys = '"' },
			{ mode = { 'i', 'c' }, keys = '<C-r>' },
			-- Window commands
			{ mode = 'n', keys = '<C-w>' },
			-- `z` key
			{ mode = { 'n', 'x' }, keys = 'z' },
			-- mini.bracketed
			{ mode = 'n', keys = '[' },
			{ mode = 'n', keys = ']' },
		},

		clues = {
			-- Enhance this by adding descriptions for <Leader> mapping groups
			miniclue.gen_clues.g(),
			miniclue.gen_clues.marks(),
			miniclue.gen_clues.registers(),
			miniclue.gen_clues.windows(),
			miniclue.gen_clues.z(),
		},
	}
end

do
	-- for autopairs. works just like/better than blink.pairs
	-- and doesn't require a fucking library
	require('mini.pairs').setup {
		mappings = {
			-- {|} + <Space> -> { | }. Two spaces are inserted and the cursor
			[' '] = {
				action = 'open',
				pair = '  ',
				neigh_pattern = '{}',
				register = { bs = true, cr = true },
			},
		},
	}
end

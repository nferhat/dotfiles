-- mini.nvim -*- the other uber plugin
-- Contains cool stuff, self-contained modules...

local api = vim.api

vim.schedule(function()
	vim.pack.add { 'https://github.com/nvim-mini/mini-git' }
	require('mini.git').setup()
	-- I don't need much of git except having the better git command
	vim.keymap.set(
		'n',
		'<leader>G',
		function() api.nvim_feedkeys(':Git ', 'n', false) end,
		{ desc = 'Git command' }
	)
end)

-- for autopairs. works just like/better than blink.pairs
-- and doesn't require a fucking library
api.nvim_create_autocmd({ 'InsertEnter' }, {
	once = true,
	callback = function()
		vim.pack.add { 'https://github.com/nvim-mini/mini.pairs' }
		require('mini.pairs').setup {
			mappings = {
				-- {|} + <Space> -> { | }. Two spaces are inserted and the cursor
				[' '] = {
					action = 'open',
					pair = '  ',
					neigh_pattern = '{}',
					register = { bs = true, cr = false },
				},
			},
		}
	end,
})

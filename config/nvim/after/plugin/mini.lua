-- mini.nvim -*- the other uber plugin
-- Contains cool stuff, self-contained modules...

local api = vim.api

-- git. :Git only exists after setup, so load on first <leader>G
vim.keymap.set('n', '<leader>G', function()
    if not _G.MiniGit then
        vim.pack.add { 'https://github.com/nvim-mini/mini-git' }
        require('mini.git').setup()
    end
    api.nvim_feedkeys(':Git ', 'n', false)
end, { desc = 'Git command' })
print 'fck'

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

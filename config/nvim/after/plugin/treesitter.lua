-- treesitter.lua -*- install parsers
-- FIXME: Use package manager

vim.pack.add {
	{
		src = 'https://github.com/nvim-treesitter/nvim-treesitter',
		version = 'main',
	},
}

require('nvim-treesitter').setup {
	highlight = { enable = true, use_languagetree = true },
	indent = { enable = true },
}

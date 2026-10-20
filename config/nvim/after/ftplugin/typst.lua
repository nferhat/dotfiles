-- typst-preview.nvim is a really useful plugin
-- recommend to anyone that uses typst

vim.pack.add {
	{
		src = 'https://github.com/chomosuke/typst-preview.nvim',
		version = vim.version.range '1.*',
	},
}

require('typst-preview').setup {}

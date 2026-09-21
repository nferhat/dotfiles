return {
	'MeanderingProgrammer/render-markdown.nvim',
	ft = "markdown",
	dependencies = { 'nvim-treesitter/nvim-treesitter' },
	opts = {
		render_modes = true,          -- even in insert!
		anti_conceal = { enabled = false }, -- annoying
		preset = 'obsidian',
		sign = { enabled = false },   -- I really dont need it
		latex = { enabled = true },
		code = {
			border = "thick",
			width = 'block',
			min_width = 100,
			inline_pad = 1,
			left_pad = 1,
		},
		heading = {
			border = true,
			border_virtual = true,
			icons = "",
			sign = false,
			left_pad = 2,
			position = "inline",
			width = 'block',
			min_width = 100,
		},
		bullet = {
			icons = { '-', '*' },
			highlight = 'RenderMarkdownBullet',
		},
		completions = { lsp = { enabled = true } },
		pipe_table = { min_width = 12, border_virtual = true, cell = 'trimmed' },

	},
}

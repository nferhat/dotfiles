-- Plugins are managed with Lazy.
--
-- Unlike my previous configuration(s), I will try to not install plugins
-- that I see unfit, I will try basic lazy-loading. The configuration will only
-- have (hopefully) what I need.

local M = {
	-- Integration with direnv, which I use to provide LSPs and tools for developing
	-- through nix devShells
	{ "direnv/direnv.vim", event = "VeryLazy" },

	-- Provide parsers, automatically install them
	-- FIXME: Use nix instead?
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		opts = {
			highlight = { enable = true, use_languagetree = true },
			indent = { enable = true },
		},
		build = ":TSUpdate",
		branch = "main",
		config = function(_, opts)
			require("nvim-treesitter").setup(opts)
		end,
	},

	-- Library for blink stuff.
	"saghen/blink.lib",
	{
		"saghen/blink.pairs",
		tag = "v0.6.0",
		build = function()
			require("blink.pairs").download():pwait(60000)
		end,

		event = "InsertEnter",
		opts = {
			mappings = { cmdline = false },
			highlights = { enabled = false },
		},
		config = true,
	},

	-- Gitsigns, nothing fancy
	-- TODO: Maybe write a copy myself? I don't make use of all the features this plugin has.
	{
		"lewis6991/gitsigns.nvim",
		event = "User FilePost",
		opts = {
			signs = {
				add = { text = "┃" },
				change = { text = "┃" },
				delete = { text = "┃" },
				topdelete = { text = "┃" },
				changedelete = { text = "┃" },
				untracked = { text = "┃" },
			},
			signs_staged = {
				add = { text = "┃" },
				change = { text = "┃" },
				delete = { text = "┃" },
				topdelete = { text = "┃" },
				changedelete = { text = "┃" },
				untracked = { text = "┃" },
			},
			signs_staged_enable = true,
			signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
			current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
			current_line_blame_opts = { virt_text = true, virt_text_pos = "right_align" },
			current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
			update_debounce = 100,
		},
	},

	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = "markdown",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = {
			enable = true,
			render_modes = true, -- even in insert!
			anti_conceal = { enabled = false }, -- annoying
			sign = { enabled = false }, -- I really dont need it
			latex = { enabled = true },
			code = { border = "thick", inline_pad = 1, left_pad = 1 },
			heading = { border = true, border_virtual = true, icons = " " },
			completions = { lsp = { enabled = true } },
			dashed_line = { width = 15 },
			pipe_table = { enabled = true, style = "heavy" },
			ignore = function(id)
				-- Disables for LSP popups, since it just looks weird.
				return vim.bo[id].buftype == "nofile"
			end,
		},
	},

	{
		"chomosuke/typst-preview.nvim",
		ft = "typst",
		version = "1.*",
		opts = {}, -- lazy.nvim will implicitly calls `setup {}`
	},

	-- it's a small plugin
	{ "tpope/vim-sleuth", lazy = false },
}

return M

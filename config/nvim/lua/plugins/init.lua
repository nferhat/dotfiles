-- Plugins are managed with Lazy.
--
-- Unlike my previous configuration(s), I will try to not install plugins
-- that I see unfit, I will try basic lazy-loading. The configuration will only
-- have (hopefully) what I need.

local M = {
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
			on_attach = function(buffer)
				local g = require("gitsigns")

				vim.keymap.set("n", "]h", function()
					g.nav_hunk("next")
				end, { buffer = buffer, desc = "Next git hunk" })
				vim.keymap.set("n", "[h", function()
					g.nav_hunk("prev")
				end, { buffer = buffer, desc = "Next previous hunk" })
				vim.keymap.set("n", "<leader>gr", function()
					g.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { buffer = buffer, desc = "Reset hunk" })
				vim.keymap.set("n", "<leader>gs", function()
					g.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { buffer = buffer, desc = "Stage hunk" })

				vim.keymap.set("n", "<leader>gR", g.reset_buffer, { buffer = buffer, desc = "Reset buffer" })
				vim.keymap.set("n", "<leader>gS", g.stage_buffer, { buffer = buffer, desc = "Stage buffer" })
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
	{ "tpope/vim-sleuth",  lazy = false },
}

return M

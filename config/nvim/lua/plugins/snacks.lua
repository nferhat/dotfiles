Snacks = Snacks

return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		quickfile = {}, -- Simple yet really useful
		input = { win = { border = "single" } },
		-- No need for these.
		dashboard = { enabled = false },

		-- Quick styling since this configuration has a "blocky" look/feel, with border=single
		styles = {
			-- Why is it mapped to normal by default!?
			scratch = { wo = { winhighlight = "NormalFloat:NormalFloat" }, border = "single" },
			-- Make the input slightly smaller, and slightly lower on the screen
			input = { border = "single", row = 0.35, width = 40 },
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
				wo = { winhighlight = "NormalFloat:Normal" },
				w = { snacks_main = true },
			},
		},

		-- Quick scratch buffer, useful todo quick reasoning/thinking
		-- I mostly need it to write stuff with bullet points/whatnot
		scratch = { ft = "markdown" },

		-- Better ordering, nothing special though.
		statuscolumn = {
			left = { "mark", "sign" },
			right = { "fold", "git" },
			folds = { open = false, git_hl = true },
			git = { patterns = { "GitSign" } },
			refresh = 50, -- refresh at most every 100ms
		},

		-- Replaces indent-blankline.nvim
		indent = { char = "▎", scope = { underline = true } },

		-- Explorer that mimics really well dired/ivy.
		-- Cool stuff, can't complain!
		explorer = { replace_netrw = true, trash = true },

		-- A picker that I find more useful (and kinda cooler) than telescope.nvim
		-- 1. No dependency on external plugin for correct fuzzy matching
		-- 2. Better ivy theme than telescope
		-- 3. Replace default neovim UI handlers. Much better than using the keyboard.
		picker = {
			auto_close = true,
			icons = { files = { enabled = false } },
			layouts = {
				-- Enable borders for the default picker.
				default = {
					layout = {
						box = "horizontal",
						width = 0.8,
						min_width = 120,
						height = 0.8,
						border = "none",
						{
							box = "vertical",
							title = "{title} {live} {flags}",
							border = "single",
							{ win = "input", height = 1, border = "bottom" },
							{ win = "list", border = "none" },
						},
						{ win = "preview", border = "single", width = 0.6, minimal = true },
					},
				},
				select = {
					layout = {
						box = "horizontal",
						width = 0.8,
						min_width = 120,
						height = 0.8,
						border = "none",
						{
							box = "vertical",
							title = "{title} {live} {flags}",
							border = "single",
							{ win = "input", height = 1, border = "bottom" },
							{ win = "list", border = "none" },
						},
						{ win = "preview", border = "single", width = 0.6, minimal = true },
					},
				},
				-- Variation of default picker with a smaller window size and larger preview window
				-- I mostly care about what im about to jump to when im inside the buffer picker
				buffers = {
					layout = {
						box = "horizontal",
						width = 0.3,
						min_width = 120,
						height = 0.4,
						{ win = "list", border = "single" },
						{ win = "preview", border = "single", width = 0.65, minimal = true },
					},
				},
				-- A variation of the ivy picker without prompt. I don't need it for a file explorer
				explorer_no_prompt = {
					hidden = { "input" },
					layout = {
						box = "horizontal",
						width = 0.8,
						height = 0.6,
						{ win = "list", title_pos = nil, border = "single" },
						{ win = "preview", width = 0.6, border = "single", minimal = true },
					},
				},
				-- Make select smaller
				select = {
					hidden = { "preview" },
					layout = {
						backdrop = false,
						width = 0.3,
						min_width = 35,
						height = 0.4,
						min_height = 3,
						box = "vertical",
						border = true,
						title = "{title}",
						title_pos = "center",
						{ win = "input", height = 1, border = "bottom" },
						{ win = "list", border = "none" },
						{ win = "preview", title = "{preview}", height = 0.4, border = "top" },
					},
				},
			},

			sources = {
				explorer = {
					tree = true,
					layout = "explorer_no_prompt",
					follow_file = true,
					auto_close = true,
					win = { icons = { dir = "", dir_open = "" }, files = { enabled = false } },
				},
				buffers = { layout = "buffers" },
				recent = {
					layout = {
						preset = "default",
						layout = { width = 0.5, height = 0.6 },
					},
				},
			},
		},
	},
	keys = {
		{
			"<leader><space>",
			function()
				Snacks.picker.explorer()
			end,
			desc = "File Explorer",
		},

		-- Top Pickers & Explorer
		{
			"<leader>f",
			function()
				Snacks.picker.files()
			end,
			desc = "Find Files",
		},
		{
			"<leader>q",
			function()
				Snacks.picker.qflist()
			end,
			desc = "Find Files",
		},
		{
			"<leader>b",
			function()
				Snacks.picker.buffers()
			end,
			desc = "Buffers",
		},
		{
			"<leader>/",
			function()
				Snacks.picker.grep()
			end,
			desc = "Grep",
		},
		{
			"<leader>D",
			function()
				Snacks.picker.diagnostics()
			end,
			desc = "Workspace Diagnostics",
		},
		{
			"<leader>o",
			function()
				Snacks.picker.recent()
			end,
			desc = "Recent",
		},
		{
			"<leader>gl",
			function()
				Snacks.picker.git_log()
			end,
			desc = "Log",
		},
		{
			"<leader>gL",
			function()
				Snacks.picker.git_log_line()
			end,
			desc = "Log Line",
		},
		{
			"<leader>gs",
			function()
				Snacks.picker.git_status()
			end,
			desc = "Status",
		},
		{
			"<leader>gS",
			function()
				Snacks.picker.git_stash()
			end,
			desc = "Stash",
		},
		{
			"<leader>gd",
			function()
				Snacks.picker.git_diff()
			end,
			desc = "Diff (Hunks)",
		},
		{
			"<leader>gf",
			function()
				Snacks.picker.git_log_file()
			end,
			desc = "Log File",
		},
		-- Grep
		-- LSP
		{
			"gd",
			function()
				Snacks.picker.lsp_definitions()
			end,
			desc = "Goto Definition",
		},
		{
			"gD",
			function()
				Snacks.picker.lsp_declarations()
			end,
			desc = "Goto Declaration",
		},
		{
			"gr",
			function()
				Snacks.picker.lsp_references()
			end,
			nowait = true,
			desc = "References",
		},
		{
			"gI",
			function()
				Snacks.picker.lsp_implementations()
			end,
			desc = "Goto Implementation",
		},
		{
			"gy",
			function()
				Snacks.picker.lsp_type_definitions()
			end,
			desc = "Goto T[y]pe Definition",
		},
		{
			"gai",
			function()
				Snacks.picker.lsp_incoming_calls()
			end,
			desc = "C[a]lls Incoming",
		},
		{
			"gao",
			function()
				Snacks.picker.lsp_outgoing_calls()
			end,
			desc = "C[a]lls Outgoing",
		},

		{
			"<leader>z",
			function()
				Snacks.zen()
			end,
			desc = "Toggle Zen Mode",
		},
		{
			"<leader>Z",
			function()
				Snacks.zen.zoom()
			end,
			desc = "Toggle Zoom",
		},
	},
}

vim.pack.add({
	"https://github.com/lewis6991/gitsigns.nvim", -- gitsigns in the gutter
	"https://github.com/echasnovski/mini.comment", -- Commenting support
	"https://github.com/NvChad/nvim-colorizer.lua", -- colorizer doesn't need setup
	"https://github.com/lukas-reineke/indent-blankline.nvim", -- See below
	"https://github.com/windwp/nvim-autopairs", -- Only needed with a real buffer
}, { load = false })

local function load_ui_plugins()
	local theme = require("theme")

	-- Easy commenting using keybinds
	vim.cmd([[packadd! mini.comment]])
	require("mini.comment").setup({ mappings = { comment = "<C-c>" } })

	-- colorizer don't need any setup
	vim.cmd([[packadd! nvim-colorizer.lua]])

	-- Once you live with these, you will never be able to get rid of it
	vim.cmd([[packadd! nvim-autopairs]])
	require("plugins.autopairs")

	-- Git signs for seeing what changed in the codebase.
	vim.cmd([[packadd! gitsigns.nvim]])
	theme.load_skeleton("gitsigns")
	require("gitsigns").setup({
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
	})

	vim.cmd([[packadd! indent-blankline.nvim]])
	theme.load_skeleton("indent-blankline")
	require("ibl").setup({
		indent = {
			char = "│",
			highlight = "IndentGuide",
			smart_indent_cap = true,
		},
		scope = {
			enabled = true,
			highlight = "IndentGuideScope",
			char = "│",
		},
	})
end

local aug = vim.api.nvim_create_augroup("plugins-lazy", { clear = true })
vim.api.nvim_create_autocmd({ "UIEnter", "BufReadPost", "BufNewFile" }, {
	group = aug,
	callback = function(ev)
		local file = vim.api.nvim_buf_get_name(ev.buf)
		local buftype = vim.api.nvim_get_option_value("buftype", { buf = ev.buf })

		if not vim.g.ui_entered and ev.event == "UIEnter" then
			vim.g.ui_entered = true
		end

		if file ~= "" and buftype ~= "nofile" and vim.g.ui_entered then
			load_ui_plugins()
			vim.schedule(function()
				if vim.g.editorconfig then
					-- Load editorconfig only when we have a buffer
					require("editorconfig").config(ev.buf)
				end
			end)
		end
	end,
})

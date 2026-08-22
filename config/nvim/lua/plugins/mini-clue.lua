local M = {
	"echasnovski/mini.clue",
	event = "VeryLazy",
}

M.config = function()
	local miniclue = require("mini.clue")
	miniclue.setup({
		window = {
			config = { width = "auto", border = "single" },
			delay = 0,
		},
		triggers = {
			{ mode = { "n", "x" }, keys = "<Leader>" },
			{ mode = { "n", "x" }, keys = "g" },
			{ mode = { 'n', 'x' }, keys = "'" },
			{ mode = { 'n', 'x' }, keys = '`' },
			{ mode = { 'n', 'x' }, keys = '"' },
			{ mode = { 'i', 'c' }, keys = '<C-r>' },
			{ mode = 'n',          keys = '<C-w>' },
			{ mode = { 'n', 'x' }, keys = 'z' },
		},

		clues = {
			miniclue.gen_clues.square_brackets(),
			miniclue.gen_clues.builtin_completion(),
			miniclue.gen_clues.g(),
			miniclue.gen_clues.marks(),
			miniclue.gen_clues.registers(),
			miniclue.gen_clues.windows(),
			miniclue.gen_clues.z(),
			-- -- <leader>n always maps to neorg
			-- { mode = "n", keys = "<Leader>n", desc = "+Neorg" },
			-- { mode = "n", keys = "<Leader>ni", desc = "+Insert" },
			-- { mode = "n", keys = "<Leader>nt", desc = "+Task" },
			-- { mode = "n", keys = "<Leader>nl", desc = "+List" },
		},
	})
end

return M

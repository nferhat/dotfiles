-- Plugins are managed with neovim's builtin package manager that was
-- added in Neovim nightly 0.12, it helps me cut down on dependencies and
-- moving parts in this config.
--
-- Unlike my previous configuration(s), I will try to not install plugins
-- that I see unfit, I will try basic lazy-loading. The configuration will only
-- have (hopefully) what I need.

-- Telescope, the go-to tool for navigating all my codebases
require("plugins.telescope")
-- LSP, for completions, diagnostics, and all the nice editor stuff
-- This is the primary thing that drives the dev experience.
require("plugins.lsp")
-- The completion menu
require("plugins.completion")
-- Some other plugins don't need to be loaded right away, postpone their loading
-- once we actually get a buffer opened
require("plugins.lazy")

-- Other plugins here don't really deserve to have their own files
vim.pack.add({
	"https://github.com/Vonr/align.nvim", -- Aligning, see keybinds below
	"https://github.com/famiu/bufdelete.nvim", -- I need it for :Bdelete only
	"https://github.com/nvim-treesitter/nvim-treesitter", -- parsers with treesitter
})

-- Setup automatic parsers
require("nvim-treesitter.configs").setup({
	auto_install = true,
	highlight = { enable = true },
})

-- Aligning keybinds
local align = require "align"
vim.keymap.set("x", "aa", function()
    align.align_to_char({ length = 1 })
end, { desc = "Align selection to character" })
vim.keymap.set("x", "aw", function()
    align.align_to_string({ preview = true, regex = true })
end, { desc = "Align selection" })
vim.keymap.set('n', 'gaw', function()
    align.operator(align.align_to_string, {
        regex = false,
        preview = true,
    })
end, { desc = "Align selection to string" })
-- Example gaaip to align a paragraph to 1 character
vim.keymap.set('n', 'gaa', function()
    align.operator(align.align_to_char)
end, { desc = "Align to char" })


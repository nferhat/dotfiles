-- Plugins are managed with Lazy.
--
-- Unlike my previous configuration(s), I will try to not install plugins
-- that I see unfit, I will try basic lazy-loading. The configuration will only
-- have (hopefully) what I need.

local M = {
    {
        "famiu/bufdelete.nvim",
        keys = { { "<leader>x", ":Bdelete!<CR>", desc = "Close buffer" } },
    },

    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPost", "BufNewFile", "User FilePost" },
        cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
        opts = {
            highlight = { enable = true, use_languagetree = true },
            indent = { enable = true },
        },
        build = ":TSUpdate",
        branch = "master",
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        event = "User FilePost",
        main = "ibl",
        opts = {
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
        },
        config = function(_, opts)
            require("ibl").setup(opts)
        end,
    },

    {
        "Vonr/align.nvim",
        branch = "v2",
        lazy = true,
        init = function()
            -- Create your mappings here
            vim.keymap.set("x", "aa", function()
                local align = require "align"
                align.align_to_char { length = 1 }
            end, { desc = "Align selection to character" })
            vim.keymap.set("x", "aw", function()
                local align = require "align"
                align.align_to_string { preview = true, regex = true }
            end, { desc = "Align selection" })
            vim.keymap.set("n", "gaw", function()
                local align = require "align"
                align.operator(align.align_to_string, {
                    regex = false,
                    preview = true,
                })
            end, { desc = "Align selection to string" })
            vim.keymap.set("n", "gaa", function()
                local align = require "align"
                align.operator(align.align_to_char)
            end, { desc = "Align to char" })
        end,
    },

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
}

return M

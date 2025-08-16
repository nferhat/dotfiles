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
        branch = "master",
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end,
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
}

return M

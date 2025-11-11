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
        "saghen/blink.pairs",
        build = "nix run .#build-plugin",
        event = "InsertEnter",
        opts = {
            mappings = { cmdline = false },
            highlights = { enabled = false },
        },
        config = true,
    },

    {
        "rcarriga/nvim-notify",
        config = function()
            local notify = require "notify"
            local stages = require "notify.stages.slide" "top_down"
            -- Override vim.notify so we can use nvim-notify with it.
            -- This basically allows all plugins to use nvim-notify to display any message they'd
            -- like to using notify, as long as they use vim.notify as for message logging.
            vim.notify = notify

            notify.setup {
                timeout = 4500, -- in milliseconds.
                render = "wrapped-compact",
                border = "solid",
                max_width = 50,
                fps = 180, -- smoooooth
                stages = {
                    function(...)
                        local opts = stages[1](...)
                        if opts then
                            opts.border = "solid"
                        end
                        return opts
                    end,
                    unpack(stages, 2),
                },
                fade_in_slide_out = true,
            }
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

    {
        'MeanderingProgrammer/render-markdown.nvim',
        ft = "markdown",
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
        ---@module 'render-markdown'
        ---@type render.md.UserConfig
        opts = {
            render_modes = true, -- even in insert!
            anti_conceal = { enabled = false }, -- annoying
            preset = 'obsidian',
            sign = { enabled = false }, -- I really dont need it
            latex = { enabled = true },
            code = { border = "thick", inline_pad = 1, left_pad = 1 },
            heading = { border = true, border_virtual = true, icons = " " },
            completions = { lsp = { enabled = true } },
        },
    },

}

return M

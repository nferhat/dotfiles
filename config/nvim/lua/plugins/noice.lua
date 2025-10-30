local kind_icons = {
    Text = "t",
    Method = "M",
    Function = "F",
    Constructor = "C",
    Field = "f",
    Variable = "v",
    Class = "C",
    Interface = "I",
    Module = "m",
    Property = "p",
    Unit = "u",
    Value = "v",
    Enum = "E",
    Keyword = "k",
    Snippet = "S",
    Color = "c",
    File = "f",
    Reference = "r",
    Folder = "F",
    EnumMember = "e",
    Constant = "C",
    Struct = "S",
    Event = "e",
    Operator = "O",
    TypeParameter = "t",
}

local M = {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim" },
    keys = {
        { "<leader>\\", ":Noice pick<CR>", desc = "Picker of recent messages" },
    },

    opts = {
        -- Enable the noice.nvim messages UI.
        -- This replaces the default neovim message handlers and routes them to other places.
        messages = {
            enabled = true,
            view = "notify",
            view_error = "notify",
            view_warn = "notify",
            view_history = "notify",
            view_search = "virtualtext",
        },

        -- Override/enhance the default LSP user interfaces. progress and hover are the
        -- one that interests us the most here.
        lsp = {
            -- Enable LSP progress tracking, pretty useful!
            progress = { enabled = true },
            hover = { enabled = true, silent = true },
            -- LSP message tracking too, using the min view
            message = { enable = true, view = "mini" },
            override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
                ["cmp.entry.get_documentation"] = true,
            },
        },

        -- cmdline: Replace neovim's default command line with a pretty interactive popup!
        -- This configuration (with the views config below) makes it look like a vscode-ish
        -- command palette!
        cmdline = {
            enabled = true,
            view = "cmdline_popup",
            format = {
                cmdline = { pattern = "^:", icon = ">", lang = "vim" },
                search_down = { kind = "search", pattern = "^/", icon = "/", lang = "regex" },
                search_up = { kind = "search", pattern = "^%?", icon = "?", lang = "regex" },
                filter = { pattern = "^:%s*!", icon = "~", lang = "bash" },
                lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = ">", lang = "lua" },
                help = { pattern = "^:%s*he?l?p?%s+", icon = "?" },
            },
        },
        -- notify: Intercept neovim's messages and show them using notify-nvim and other views
        notify = { enabled = true, backend = "mini" },
        -- A custom popup menu, nothing special
        popupmenu = { enabled = true, backend = "nui", kind_icons = kind_icons },
        views = {
            -- cmdline_popup+popupmenu makes the commandline look like a vscode-ish/Zed
            -- Ctrl+P menu, which is really slick!
            cmdline_popup = {
                backend = "popup",
                relative = "editor",
                focusable = false,
                position = { row = 10, col = "50%" },
                size = { height = "auto", width = 50 },
                border = { style = "solid" },
            },
            popupmenu = {
                relative = "editor",
                position = { row = 13, col = "50%" },
                size = { max_height = 10, width = 50 },
                border = { style = "solid" },
                kind_icons = kind_icons,
            },
            -- Add some padding for the LSP hover doc, since it looks quite good with the
            -- solid border.
            hover = {
                border = { style = "solid", padding = { 0, 1 } },
                relative = "cursor",
            },
        },

        -- Override some routes to avoid too much noise...
        routes = {
            {
                filter = { event = "msg_show", kind = "", find = "written" },
                opts = { skip = true },
            },
        },
    },
}

return M

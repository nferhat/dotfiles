local M = {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
    },
}

M.config = function()
    local noice = require "noice"

    local kind_icons = {
        Text = "",
        Method = "",
        Function = "",
        Constructor = "",
        Field = "",
        Variable = "",
        Class = "",
        Interface = "",
        Module = "",
        Property = "",
        Unit = "",
        Value = "",
        Enum = "",
        Keyword = " ",
        Snippet = "",
        Color = "",
        File = "",
        Reference = "",
        Folder = "",
        EnumMember = "",
        Constant = "",
        Struct = "",
        Event = "",
        Operator = "",
        TypeParameter = "",
    }

    noice.setup {
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
                input = {}, -- Used by input()
            },
        },
        messages = {
            enabled = true,
            view = "notify",
            view_error = "notify",
            view_warn = "notify",
            view_history = "messages",
            view_search = "virtualtext",
        },
        notify = {
            enabled = true,
            view = "notify",
        },
        popupmenu = {
            enabled = true,
            backend = "nui",
            kind_icons = kind_icons,
        },
        lsp = {
            progress = { enabled = true },
            hover = { enabled = true, silent = false },
            message = { enable = true, view = "mini" },
            override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
                ["cmp.entry.get_documentation"] = true,
            },
        },
        views = {
            cmdline_popup = {
                backend = "popup",
                relative = "editor",
                focusable = false,
                position = { row = 10, col = "50%" },
                size = { height = "auto", width = 80 },
                border = { style = "single" },
            },
            cmdline_popupmenu = {
                zindex = 210,
                view = "popupmenu",
                border = {
                    style = { "│", "─", "│", "│", "┘", "─", "└", "│" },
                },
                kind_icons = true,
            },
            popupmenu = {
                relative = "editor",
                position = { row = 12, col = "50%" },
                size = { height = 10, width = 80 },
                border = { style = "single" },
                kind_icons = kind_icons,
            },
            hover = {
                border = { style = "single", padding = { 0, 0 } },
                relative = "cursor",
                position = { row = 2, col = -3 },
            },
        },
    }

    require("ui.theme").load_skeleton "diagnostics"
    require("ui.theme").load_skeleton "noice"
end

return M

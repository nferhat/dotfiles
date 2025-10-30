-- The completion menu
local M = {
    "saghen/blink.cmp",
    version = "1.6.0",
    event = "InsertEnter",
    dependencies = {
        -- Battery of pre-made snippets
        "rafamadriz/friendly-snippets",
    },
}

M.config = function()
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

    require("blink.cmp").setup {
        keymap = {
            preset = "enter",
            ["<Tab>"] = {
                -- By default, we select next
                "select_next",
                "snippet_forward",
                "select_next",
                "fallback",
            },
            ["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
            ["<C-s>"] = {
                function(c)
                    c.show { providers = { "snippets" } }
                end,
            },
        },
        appearance = {
            nerd_font_variant = "mono",
            kind_icons = kind_icons,
        },
        signature = {
            enabled = true,
            trigger = { show_on_keyword = true, show_on_insert = true },
            -- winhighlight = 'Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder',
        },
        completion = {
            menu = {
                scrollbar = false,
                border = "none",
                draw = {
                    padding = { 0, 1 }, -- padding only on right side
                    columns = {
                        { "kind_icon" },
                        { "label", width = { fill = true } },
                        -- { "label_description" },
                    },
                    components = {
                        kind_icon = {
                            text = function(ctx)
                                return " " .. ctx.kind_icon .. ctx.icon_gap .. " "
                            end,
                        },
                    },
                },
            },
            list = { selection = { auto_insert = true, preselect = true } },
            documentation = { auto_show = true },
            trigger = {
                show_on_keyword = false,
                show_on_trigger_character = false,
                show_on_accept_on_trigger_character = false,
            },
        },
        fuzzy = { implementation = "prefer_rust_with_warning", prebuilt_binaries = { force_version = "v1.6.0" } },
    }
end

return M

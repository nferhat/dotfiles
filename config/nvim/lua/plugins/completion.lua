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
        appearance = { nerd_font_variant = "mono" },
        signature = {
            enabled = true,
            trigger = { show_on_keyword = true, show_on_insert = true },
            -- winhighlight = 'Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder',
        },
        completion = {
            menu = {
                scrollbar = true,
                border = "solid",
                draw = {
                    padding = { 1, 1 }, -- padding only on right side
                    columns = {
                        -- { "kind_icon" },
                        { "label", width = { fill = true } },
                        -- { "label_description" },
                    },
                    components = {
                        label = {
                            highlight = function(ctx)
                                -- label and label details
                                local label = ctx.label
                                local highlights = {
                                    { 0, #label, group = ctx.deprecated and 'BlinkCmpLabelDeprecated' or ctx.kind_hl },
                                }
                                if ctx.label_detail then
                                    table.insert(highlights, { #label, #label + #ctx.label_detail, group = 'BlinkCmpLabelDetail' })
                                end

                                if vim.list_contains(ctx.self.treesitter, ctx.source_id) and not ctx.deprecated then
                                    -- add treesitter highlights
                                    vim.list_extend(highlights, require('blink.cmp.completion.windows.render.treesitter').highlight(ctx))
                                end

                                -- characters matched on the label by the fuzzy matcher
                                for _, idx in ipairs(ctx.label_matched_indices) do
                                    table.insert(highlights, { idx, idx + 1, group = 'BlinkCmpLabelMatch' })
                                end

                                return highlights
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
        cmdline = { enabled = false, completion = { ghost_text = { enabled = true } } },
        fuzzy = { implementation = "prefer_rust_with_warning", prebuilt_binaries = { force_version = "v1.6.0" } },
    }
end

return M

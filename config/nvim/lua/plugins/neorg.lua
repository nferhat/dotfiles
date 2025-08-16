-- The life-changer, note-taker, organizer, everything
-- Trying to get rid of obsidian for my stuff
local M = {
    "nvim-neorg/neorg",
    ft = "norg",
    version = "*", -- Pin Neorg to the latest stable release
    cmd = "Neorg",
    dependencies = { "benlubas/neorg-interim-ls" },
}

M.config = function()
    local neorg = require "neorg"

    neorg.setup {
        load = {
            -- The default modules
            ["core.defaults"] = {},
            -- Hide stuff with icons, makes it much nicer to read
            ["core.concealer"] = {
                config = {
                    icon_preset = "diamond",
                    icons = {
                        code_block = {
                            spell_check = false, -- this should be by default
                            content_only = false, -- also dim @code and @end
                        },
                        markup = {
                            spoiler = { icon = "─" },
                        },
                        todo = {
                            recurring = { icon = "" },
                            cancelled = { icon = "" },
                            uncertain = { icon = "?" },
                            done = { icon = "" },
                            on_hold = { icon = "" },
                            urgent = { icon = "" },
                        },
                    },
                },
            },

            -- Completion to make my life easier
            -- No blink.cmp support yet, use external shim LSP
            ["core.completion"] = {
                config = {
                    engine = { module_name = "external.lsp-completion" },
                },
            },
            ["external.interim-ls"] = {},
            -- Directory manager
            -- Just put my notes in a single place
            ["core.dirman"] = {
                config = {
                    workspaces = {
                        notes = "~/Documents/notes",
                        journal = "~/Documents/jrnl",
                    },
                    default_workspace = "notes",
                },
            },
            -- Apparently you should do using these instead of setting in your theme.
            ["core.highlights"] = {
                config = {
                    dim = {
                        tags = {
                            ranged_verbatim = {
                                code_block = {
                                    affect = "background",
                                    percentage = 20,
                                    reference = "Normal",
                                },
                            },
                        },
                    },
                },
            },
            -- Make this actually dimmed
            ["core.todo-introspector"] = {
                config = { highlight_group = "LspInlayHint" },
            },
        },
    }
end

return M

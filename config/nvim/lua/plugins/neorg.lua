-- The life-changer, note-taker, organizer, everything
-- Trying to get rid of obsidian for my stuff
local M = {
    "nvim-neorg/neorg",
    lazy = false,  -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
    version = "*", -- Pin Neorg to the latest stable release
    dependencies = { "benlubas/neorg-interim-ls" }
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
                    icons = {
                        code_block = {
                            spell_check = false,  -- this should be by default
                            content_only = false, -- also dim @code and @end
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
                    },
                },
            },
        }
    }
end

return M

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
            -- I don't like the default keys.
            ["core.keybinds"] = { config = { default_keybinds = false } },

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

    local set_keymap = vim.keymap.set
    -- By default, I'll do most of my stuff with <leader>n, where n is for **N**eorg
    set_keymap("n", "<leader>n", "<Cmd>Neorg index<CR>", { desc = "Open index" })
    set_keymap("n", "<leader>nC", "<Plug>(neorg.looking-glass.magnify-code-block)", { desc = "Magnify code block" })
    set_keymap("n", "<leader>nn", "<Plug>(neorg.dirman.new-note)", { desc = "New note" })
    -- <leader>ni - **I**nsert something
    set_keymap("n", "<leader>nid", "<Plug>(neorg.tempus.insert-date)", { desc = "Insert date" })
    -- <leader>nl - **L**ist manipulation
    set_keymap("n", "<leader>nli", "<Plug>(neorg.pivot.list.insert)", { desc = "Invert all list elements" })
    set_keymap("n", "<leader>nlt", "<Plug>(neorg.pivot.list.toggle)", { desc = "Toggle all list elements" })
    -- <leader>nt - **T**ask/todo
    set_keymap("n", "<leader>nta", "<Plug>(neorg.qol.todo-items.todo.task-ambiguous)", { desc = "Mark task as ambiguous" })
    set_keymap("n", "<leader>ntc", "<Plug>(neorg.qol.todo-items.todo.task-cancelled)", { desc = "Mark task as cancelled" })
    set_keymap("n", "<leader>ntd", "<Plug>(neorg.qol.todo-items.todo.task-done)", { desc = "Mark task as done" })
    set_keymap("n", "<leader>nth", "<Plug>(neorg.qol.todo-items.todo.task-on-hold)", { desc = "Mark task as on-hold" })
    set_keymap("n", "<leader>nti", "<Plug>(neorg.qol.todo-items.todo.task-important)", { desc = "Mark task as important" })
    set_keymap("n", "<leader>ntr", "<Plug>(neorg.qol.todo-items.todo.task-recurring)", { desc = "Mark task as recurring" })
    set_keymap("n", "<leader>ntu", "<Plug>(neorg.qol.todo-items.todo.task-undone)", { desc = "Mark task as undone" })

    -- Jumping between headers
    set_keymap("x", "]h", "<Plug>(neorg.treesitter.next.heading)", { desc = "Jump to next norg heading" })
    set_keymap("x", "]h", "<Plug>(neorg.treesitter.previous.heading)", { desc = "Jump to previous norg heading" })

    -- Some insert-mode action
    set_keymap("i", "<M-CR>", "<Plug>(neorg.itero.next-iteration)")
end

return M

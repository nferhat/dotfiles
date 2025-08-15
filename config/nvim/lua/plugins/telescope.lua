-- Telescope, the go-to tool for navigating all my codebases

local M = {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    keys = {
        -- stylua: ignore start
        { "<leader>/",        ":Telescope live_grep<CR>",               desc = "Workspace live grep" },
        { [[<leader>\]],      ":Telescope search_history<CR>",          desc = "Search History" },
        { "<leader>@",        ":Telescope treesitter<CR>",              desc = "Treesitter symbols" },
        { "<leader>b",        ":Telescope buffers<CR>",                 desc = "Buffer picker" },
        { "<leader>f",        ":Telescope find_files<CR>",              desc = "File picker" },
        { "<leader>o",        ":Telescope oldfiles<CR>",                desc = "Recent file picker" },
        { "<leader>?",        ":Telescope keymaps<CR>",                 desc = "Keymaps picker" },
        { "z=",               ":Telescope spell_suggest<CR>",           desc = "Spell suggestions" },
        { "<leader><leader>", ":Telescope file_browser path=%:p:h<CR>", desc = "File browser" },
        -- stylua: ignore end
    },
    dependencies = {
        { "nvim-lua/plenary.nvim", module = { "plenary" } },
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        { "nvim-telescope/telescope-file-browser.nvim" },
    },
}

M.config = function()
    local telescope = require "telescope"
    local actions = require "telescope.actions"
    local fb_actions = telescope.extensions.file_browser.actions

    require("telescope.pickers.layout_strategies").horizontal_edit = function(
        picker,
        max_columns,
        max_lines,
        layout_config
    )
        local layout =
            require("telescope.pickers.layout_strategies").horizontal(picker, max_columns, max_lines, layout_config)

        layout.prompt.title = ""
        layout.prompt.borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" }

        layout.results.title = ""
        layout.results.line = layout.results.line - 1
        layout.results.height = layout.results.height + 1

        if layout.preview then
            layout.preview.title = ""
            layout.preview.col = layout.preview.col - 1
            layout.preview.width = layout.preview.width + 1
            layout.preview.borderchars = { "─", "│", "─", "│", "┬", "┐", "┘", "└" }
            layout.results.borderchars = { "─", "│", "─", "│", "│", "│", "┴", "└" }
        else
            layout.results.borderchars = { "─", "│", "─", "│", "│", "│", "┘", "└" }
        end

        return layout
    end

    telescope.setup {
        defaults = {
            sorting_strategy = "ascending",
            selection_strategy = "reset",
            scroll_strategy = "limit",
            layout_strategy = "horizontal_edit",
            layout_config = {
                horizontal = {
                    prompt_position = "top",
                    preview_width = 0.55,
                    width = 0.8,
                    height = 0.90,
                },
                vertical = {
                    mirror = false,
                },
                width = 0.87,
                preview_cutoff = 120,
            },
            prompt_prefix = "",
            winblend = vim.opt.winblend:get(),
            selection_caret = ">> ",
            multi_icon = " * ",
            initial_mode = "insert",
            winhl = "RenamerTitle",
            mappings = {
                i = {
                    -- Cycle history
                    ["<C-up>"] = actions.cycle_history_prev,
                    ["<C-down>"] = actions.cycle_history_next,
                    -- Exit without passing to normal mode
                    ["<C-c>"] = actions.close,
                },
            },
            history = true, -- Enable keeping a prompt history
            set_env = { COLORTERM = "truecolor" },
        },
        pickers = {
            buffers = { layout_config = { width = 0.6, height = 0.7, preview_width = 0.65 }, previewer = true },
            spell_suggest = {
                layout_strategy = "horizontal_edit",
                layout_config = { width = 0.3, height = 0.4 },
                previewer = false,
                title = " ",
            },
        },
        extensions = {
            file_browser = {
                initial_mode = "normal",
                dir_icon = "",
                dir_icon_hl = "Directory",
                -- border = false,
                hijack_netrw = true,
                layout_strategy = "horizontal_edit",
                layout_config = {
                    prompt_position = "top",
                    width = 0.8,
                    height = 0.6,
                },
                mappings = {
                    ["n"] = {
                        a = fb_actions.create,
                        r = fb_actions.rename,
                        y = fb_actions.copy,
                        d = fb_actions.remove,
                        p = fb_actions.move,
                        h = fb_actions.goto_parent_dir,
                        H = fb_actions.toggle_hidden,
                        ["<BS>"] = fb_actions.goto_parent_dir,
                        ["<C-a>"] = fb_actions.select_all,
                        ["`"] = fb_actions.goto_cwd,
                    },
                },
            },
        },
    }

    pcall(telescope.load_extension, "fzf")
    pcall(telescope.load_extension, "file_browser")
end

return M

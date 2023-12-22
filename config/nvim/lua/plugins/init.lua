local utils = require "utils"

return {
    { "junegunn/vim-easy-align", cmd = "EasyAlign" },
    { "famiu/bufdelete.nvim", cmd = "Bdelete" },
    { "mbbill/undotree", cmd = "UndotreeToggle" },

    {
        "nvim-treesitter/nvim-treesitter",
        init = require("utils").lazy_load "nvim-treesitter",
        opts = {
            ensure_installed = { "markdown", "markdown_inline", "regex", "lua", "vim" },
            sync_install = true,
            auto_install = true,
            highlight = { enable = true },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "gnn",
                    node_incremental = "grn",
                    scope_incremental = "grc",
                    node_decremental = "grm",
                },
            },
            indent = { enable = true },
            context_commentstring = { enable = true, enable_autocmd = false },
        },
        config = function(_, opts)
            require("ui.theme").load_skeleton "treesitter"
            require("nvim-treesitter.configs").setup(opts)
        end,
    },

    {
        "m4xshen/autoclose.nvim",
        event = { "InsertEnter", "CmdlineEnter" },
        opts = { options = { pair_spaces = true, disable_command_mode = true } },
        config = true,
    },

    {
        "NvChad/nvim-colorizer.lua",
        init = utils.lazy_load "nvim-colorizer.lua",
        opts = { css = true }, -- all css selectors.
        config = true,
    },

    {
        "echasnovski/mini.clue",
        keys = { "<leader>", "g", "d", "c" },
        config = function()
            local miniclue = require "mini.clue"
            miniclue.setup {
                window = {
                    config = { border = borderchars, width = 45 },
                    delay = 0,
                },
                triggers = {
                    -- Leader triggers
                    { mode = "n", keys = "<Leader>" },
                    { mode = "x", keys = "<Leader>" },

                    -- Built-in completion
                    { mode = "i", keys = "<C-x>" },

                    -- `g` key
                    { mode = "n", keys = "g" },
                    { mode = "x", keys = "g" },

                    -- Marks
                    { mode = "n", keys = "'" },
                    { mode = "n", keys = "`" },
                    { mode = "x", keys = "'" },
                    { mode = "x", keys = "`" },

                    -- Registers
                    { mode = "n", keys = '"' },
                    { mode = "x", keys = '"' },
                    { mode = "i", keys = "<C-r>" },
                    { mode = "c", keys = "<C-r>" },

                    -- Window commands
                    { mode = "n", keys = "<C-w>" },

                    -- `z` key
                    { mode = "n", keys = "z" },
                    { mode = "x", keys = "z" },
                },

                clues = {
                    -- Enhance this by adding descriptions for <Leader> mapping groups
                    miniclue.gen_clues.g(),
                    miniclue.gen_clues.marks(),
                    miniclue.gen_clues.registers(),
                    miniclue.gen_clues.windows(),
                    miniclue.gen_clues.z(),
                },
            }
            require("ui.theme").load_skeleton "mini-clue"
        end,
    },

    {
        "JoosepAlviste/nvim-ts-context-commentstring",
        lazy = true,
        opts = { enable_autocmd = false },
    },
    {
        "echasnovski/mini.comment",
        keys = {
            { "gcc", mode = "n", desc = "Comment toggle current line" },
            { "gc", mode = { "n", "o" }, desc = "Comment toggle linewise" },
            { "gc", mode = "x", desc = "Comment toggle linewise (visual)" },
            { "gbc", mode = "n", desc = "Comment toggle current block" },
            { "gb", mode = { "n", "o" }, desc = "Comment toggle blockwise" },
            { "gb", mode = "x", desc = "Comment toggle blockwise (visual)" },
        },
        opts = {
            options = {
                custom_commentstring = function()
                    return require("ts_context_commentstring.internal").calculate_commentstring()
                        or vim.bo.commentstring
                end,
            },
        },
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        init = utils.lazy_load "indent-blankline.nvim",
        main = "ibl",
        opts = {
            indent = {
                -- char = "▎",
                char = "|",
                highlight = "IndentGuide",
                smart_indent_cap = true,
            },
            scope = {
                enabled = false,
                highlight = "IndentGuideScope",
                -- char = "▎",
                char = "|",
            },
        },
        config = function(_, opts)
            require("ui.theme").load_skeleton "indent-blankline"
            require("ibl").setup(opts)
        end,
    },

    {
        "L3MON4D3/LuaSnip",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
            local luasnip = require "luasnip"
            require("luasnip.loaders.from_vscode").lazy_load()

            luasnip.config.set_config {
                history = true,
                update_events = "InsertLeave,TextChanged,TextChangedI",
                region_check_events = "CursorHold,InsertEnter",
                delete_check_events = "TextChanged,InsertLeave",
            }

            vim.api.nvim_create_autocmd("InsertLeave", {
                group = vim.api.nvim_create_augroup("luasnip_unlink_node", {}),
                callback = function()
                    if
                        require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
                        and not require("luasnip").session.jump_active
                    then
                        require("luasnip").unlink_current()
                    end
                end,
            })
        end,
    },

    {
        "alexghergh/nvim-tmux-navigation",
        cond = not (os.getenv "TMUX" == nil),
        lazy = false,
        config = true,
        opts = {
            keybindings = {
                left = "<C-h>",
                down = "<C-j>",
                up = "<C-k>",
                right = "<C-l>",
                last_active = "<nop>",
                next = "<nop>",
            },
        },
    },

    {
        "stevearc/dressing.nvim",
        init = function()
            vim.ui.select = function(items, opts, on_choice)
                require("lazy").load { plugins = "dressing.nvim" }
                vim.defer_fn(function()
                    vim.ui.select(items, opts, on_choice)
                end, 0)
            end
        end,
        opts = {
            input = { enabled = false }, -- managed by noice.nvim
            select = {
                -- Override vim.ui.select() hook
                enabled = true,
                backend = { "telescope", "builtin" },
                telescope = {
                    layout_strategy = "horizontal_edit",
                    layout_config = { width = 0.5, height = 0.3 },
                },
            },
        },
    },

    {
        "NeogitOrg/neogit",
        init = function()
            vim.defer_fn(function()
                -- This is only going to be ran when we are in a git repo, so this wont hurt much.
                require("lazy").load { plugins = "neogit" }
            end, 0)
        end,
        opts = {
            disable_hint = false,
            kind = "vsplit",
            disable_line_numbers = true,
            signs = {
                hunk = { "", "" },
                item = { "", "" },
                section = { "", "" },
            },
        },
        keys = {
            { "<leader>gg", ":Neogit<CR>", desc = "Open neogit" },
            { "<leader>gc", ":Neogit commit<CR>", desc = "Commit changes" },
            { "<leader>gs", ":Gitsigns stage_hunk<CR>", desc = "Stage hunk" },
            { "<leader>gS", ":Gitsigns stage_buffer<CR>", desc = "Stage buffer" },
            { "<leader>gb", ":Gitsigns blame_line<CR>", desc = "Blame line" },
        },
        config = function(_, opts)
            require("ui.theme").load_skeleton "neogit"
            require("neogit").setup(opts)
        end,
        dependencies = {
            "lewis6991/gitsigns.nvim",
            opts = {
                signs = {
                    add = { text = "▎" },
                    change = { text = "▎" },
                    delete = { text = "▎" },
                    topdelete = { text = "▎" },
                    changedelete = { text = "▎" },
                    untracked = { text = "▎" },
                },
            },
            config = function(_, opts)
                require("gitsigns").setup(opts)
                require("ui.theme").load_skeleton "gitsigns"
            end,
        },
    },

    {
        "mfussenegger/nvim-dap",
        cmd = { "DapContinue", "DapToggleBreakpoint", "DapStepInto", "DapStepOut" },
        dependencies = { "rcarriga/nvim-dap-ui" },
        config = function()
            local dap = require "dap"

            dap.adapters.codelldb = {
                type = "server",
                port = "13727",
                executable = { command = "codelldb", args = { "--port", "13727" } },
            }
            dap.configurations.rust = {
                {
                    name = "Launch file",
                    type = "codelldb",
                    request = "launch",
                    program = function()
                        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                    end,
                    cwd = "${workspaceFolder}",
                    stopOnEntry = false,
                },
            }

            require("dapui").setup()
            require("ui.theme").load_skeleton "dap"
        end,
    },

    {
        "folke/todo-comments.nvim",
        cmd = { "TodoTelescope" },
        init = utils.lazy_load "todo-comments.nvim",
        opts = { signs = false },
        config = function(_, opts)
            require("todo-comments").setup(opts)
            require("ui.theme").load_skeleton "todoc-comments"
        end,
    },
}

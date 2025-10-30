Snacks = Snacks

return {
    "folke/snacks.nvim",
    lazy = false,
    opts = {
        quickfile = {}, -- Simple yet really useful
        scratch = { win = { border = "single" } },
        input = { win = { border = "single" } },
        -- No need for these.
        dashboard = { enabled = false },

        -- Better ordering, nothing special though.
        statuscolumn = {
            left = { "mark", "sign" },
            right = { "fold", "git" },
            folds = { open = false, git_hl = true },
            git = { patterns = { "GitSign" } },
            refresh = 50, -- refresh at most every 100ms
        },

        -- Replaces indent-blankline.nvim
        indent = { char = "│", scope = { underline = true } },

        -- Explorer that mimics really well dired/ivy.
        -- Cool stuff, can't complain!
        explorer = { replace_netrw = true, trash = true },

        -- A picker that I find more useful (and kinda cooler) than telescope.nvim
        -- 1. No dependency on external plugin for correct fuzzy matching
        -- 2. Better ivy theme than telescope
        -- 3. Replace default neovim UI handlers. Much better than using the keyboard.
        picker = {
            auto_close = true,
            layouts = {
                -- Enable borders for the default picker.
                default = {
                    layout = {
                        box = "horizontal",
                        width = 0.8,
                        min_width = 120,
                        height = 0.8,
                        border = "none",
                        {
                            box = "vertical",
                            title = "{title} {live} {flags}",
                            border = "solid",
                            { win = "input", height = 1, border = "bottom" },
                            { win = "list", border = "none" },
                        },
                        { win = "preview", border = "solid", width = 0.6, minimal = true },
                    },
                },
                -- Variation of default picker with a smaller window size and larger preview window
                -- I mostly care about what im about to jump to when im inside the buffer picker
                buffers = {
                    layout = {
                        box = "horizontal",
                        width = 0.3,
                        min_width = 120,
                        height = 0.4,
                        { win = "list", border = "solid" },
                        { win = "preview", border = "solid", width = 0.65, minimal = true },
                    },
                },
                -- A variation of the ivy picker without prompt. I don't need it for a file explorer
                explorer_no_prompt = {
                    hidden = { "input" },
                    layout = {
                        box = "horizontal",
                        height = 0.55,
                        row = -1,
                        { win = "list", title_pos = "center", border = "solid" },
                        { win = "preview", width = 0.7, border = "solid", minimal = true },
                    },
                },
                -- Make select smaller
                select = {
                    hidden = { "preview" },
                    layout = {
                        backdrop = false,
                        width = 0.3,
                        min_width = 35,
                        height = 0.4,
                        min_height = 3,
                        box = "vertical",
                        border = true,
                        title = "{title}",
                        title_pos = "center",
                        { win = "input", height = 1, border = "bottom" },
                        { win = "list", border = "none" },
                        { win = "preview", title = "{preview}", height = 0.4, border = "top" },
                    },
                },
            },
        },
    },
    keys = {
        {
            "<leader><space>",
            function()
                Snacks.picker.explorer {
                    tree = true,
                    layout = "explorer_no_prompt",
                    follow_file = true,
                    auto_close = true,
                    win = { icons = { dir = "", dir_open = "" } },
                }
            end,
            desc = "File Explorer",
        },

        -- Quick scratch buffer useful to write down stuff I think about
        { "<leader>.",  function() Snacks.scratch() end,                             desc = "Toggle Scratch Buffer" },

        -- Top Pickers & Explorer
        { "<leader>ff", function() Snacks.picker.files() end,                        desc = "Find Files" },
        { "<leader>b",  function() Snacks.picker.buffers { layout = "buffers" } end, desc = "Buffers" },
        { "<leader>/",  function() Snacks.picker.grep() end,                         desc = "Grep" },
        { "<leader>D",  function() Snacks.picker.diagnostics() end,                  desc = "Workspace Diagnostics" },
        -- more specialized find variants
        { "<leader>fg", function() Snacks.picker.git_files() end,                    desc = "Find Git Files" },
        { "<leader>fP", function() Snacks.picker.projects() end,                     desc = "Projects" },
        { "<leader>fr", function() Snacks.picker.recent() end,                       desc = "Recent" },
        { "<leader>SD", function() Snacks.picker.diagnostics_buffer() end,           desc = "Buffer Diagnostics" },
        -- git
        { "<leader>gb", function() Snacks.picker.git_branches() end,                 desc = "Git Branches" },
        { "<leader>gl", function() Snacks.picker.git_log() end,                      desc = "Git Log" },
        { "<leader>gL", function() Snacks.picker.git_log_line() end,                 desc = "Git Log Line" },
        { "<leader>gs", function() Snacks.picker.git_status() end,                   desc = "Git Status" },
        { "<leader>gS", function() Snacks.picker.git_stash() end,                    desc = "Git Stash" },
        { "<leader>gd", function() Snacks.picker.git_diff() end,                     desc = "Git Diff (Hunks)" },
        { "<leader>gf", function() Snacks.picker.git_log_file() end,                 desc = "Git Log File" },
        -- Grep
        { "<leader>SB", function() Snacks.picker.grep_buffers() end,                 desc = "Grep Open Buffers" },
        { "<leader>Sg", function() Snacks.picker.grep() end,                         desc = "Grep" },
        { "<leader>Sw", function() Snacks.picker.grep_word() end,                    desc = "Visual selection or word", mode = { "n", "x" } },
        -- search
        { '<leader>S"', function() Snacks.picker.registers() end,                    desc = "Registers" },
        { '<leader>S/', function() Snacks.picker.search_history() end,               desc = "Search History" },
        { "<leader>Sc", function() Snacks.picker.command_history() end,              desc = "Command History" },
        { "<leader>SM", function() Snacks.picker.man() end,                          desc = "Man Pages" },
        { "<leader>Sq", function() Snacks.picker.qflist() end,                       desc = "Quickfix List" },
        { "<leader>SR", function() Snacks.picker.resume() end,                       desc = "Resume" },
        { "<leader>Su", function() Snacks.picker.undo() end,                         desc = "Undo History" },
        -- LSP
        { "gd",         function() Snacks.picker.lsp_definitions() end,              desc = "Goto Definition" },
        { "gD",         function() Snacks.picker.lsp_declarations() end,             desc = "Goto Declaration" },
        { "gr",         function() Snacks.picker.lsp_references() end,               nowait = true,                     desc = "References" },
        { "gI",         function() Snacks.picker.lsp_implementations() end,          desc = "Goto Implementation" },
        { "gy",         function() Snacks.picker.lsp_type_definitions() end,         desc = "Goto T[y]pe Definition" },
        { "gai",        function() Snacks.picker.lsp_incoming_calls() end,           desc = "C[a]lls Incoming" },
        { "gao",        function() Snacks.picker.lsp_outgoing_calls() end,           desc = "C[a]lls Outgoing" },
    },
}

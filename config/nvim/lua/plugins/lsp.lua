local M = {
    -- nvim-lspconfig provides configurations in the lsp/ subdirectory.
    -- The only thing this config does is:
    --
    -- 1. Create the LspAttach hook to setup keybinds
    -- 2. Enable the LSPs I care about
    "neovim/nvim-lspconfig",
    event = "User FilePost",
    dependencies = { "saghen/blink.cmp", version = "1.6.0" },
}

M.config = function()
    -- Disable semantic highlighting, its just not good
    -- Let treesitter do the highlighting
    vim.lsp.semantic_tokens.enable(false)
    for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
        vim.api.nvim_set_hl(0, group, {})
    end
    -- Document colors are used to display for example hex codes from language servers
    -- think CSS, tailwind, etc.
    vim.lsp.document_color.enable(true, nil, { style = "virtual" })

    -- Setup diagnostic styling
    vim.diagnostic.config {
        underline = true, -- underline the area with diagnostics
        virtual_lines = {
            current_line = true,
        },
        signs = false,
        update_in_insert = true,
        severity_sort = true,
        float = {
            header = "",
            prefix = "",
            border = "single",
            style = "minimal",
        },
    }

    vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
        on_init = function(client, _)
            if client:supports_method "textDocument/semanticTokens" then
                client.server_capabilities.semanticTokensProvider = nil
            end
        end,
    })
    -- Setup lua-language-server to behave properly inside the neovim config environment
    -- IE make it recognize the vim runtime and vim globals
    vim.lsp.config("lua_ls", {
        on_init = function(client)
            if client.workspace_folders then
                local path = client.workspace_folders[1].name
                if
                    path ~= vim.fn.stdpath "config"
                    and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
                then
                    return
                end
            end

            client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
                runtime = {
                    version = "LuaJIT",
                    path = { "lua/?.lua", "lua/?/init.lua" },
                },
                -- Make the server aware of Neovim runtime files
                workspace = {
                    checkThirdParty = false,
                    library = { vim.env.VIMRUNTIME },
                },
            })
        end,
        settings = {
            Lua = {},
        },
    })
    vim.lsp.enable {
        "lua_ls",
        "rust_analyzer",
        "clangd",
        "wgsl_analyzer",
        "qmlls",
        "tinymist",
        "nixd",
    }
    function vim.lsp.restart(name)
        vim.lsp.enable(name, false)
        vim.lsp.enable(name, true)
    end

    -- Autocommand to attach onto buffers that have Lsp enabled
    -- this allows me to setup configurations
    local aug = vim.api.nvim_create_augroup("UserLspConfig", { clear = true })
    vim.api.nvim_create_autocmd("LspAttach", {
        group = aug,
        callback = function(event)
            local buffer = event.buf
            local client = assert(vim.lsp.get_client_by_id(event.data.client_id))

            local set_keymap = vim.keymap.set
            set_keymap("n", "[d", function()
                vim.diagnostic.jump { count = -1, float = true }
            end, { buffer = buffer })
            set_keymap("n", "]d", function()
                vim.diagnostic.jump { count = 1, float = true }
            end, { buffer = buffer })
            set_keymap("n", "<leader>k", function()
                vim.lsp.buf.hover {
                    border = "single",
                    max_width = math.floor(vim.o.columns * 0.6),
                    max_height = math.floor(vim.o.lines * 0.5),
                }
            end, { desc = "Hover Symbol", buffer = buffer })
            set_keymap("n", "<leader>a", vim.lsp.buf.code_action, { desc = "Buffer Code Action(s)", buffer = buffer })
            set_keymap("n", "<leader>e", vim.diagnostic.open_float, { desc = "Cursor diagnostics", buffer = buffer })
            set_keymap("n", "<leader>r", require "renamer", { desc = "Rename Symbol", buffer = buffer })
            set_keymap("i", "<C-k>", vim.lsp.buf.signature_help, { desc = "Open Signature Help", buffer = buffer })

            -- Better inlay hints (nvim >=0.10)
            if client.server_capabilities.inlayHintProvider then
                vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
            end

            -- Autoformatting
            if
                not client:supports_method "textDocument/willSaveWaitUntil"
                and client:supports_method "textDocument/formatting"
            then
                vim.api.nvim_create_autocmd("BufWritePre", {
                    group = aug,
                    buffer = buffer,
                    callback = function()
                        vim.lsp.buf.format { bufnr = buffer, id = client.id, timeout_ms = 1000 }
                    end,
                })
            end
        end,
    })
end

return M

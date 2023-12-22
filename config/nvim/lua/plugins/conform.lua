local M = {
    "stevearc/conform.nvim",
    init = require("utils").lazy_load "conform.nvim",
    keys = {
        {
            "<leader>F",
            ":lua require('conform').format()<CR>",
            mode = "n",
            desc = "Format buffer",
        },
    },
}

M.config = function()
    local conform = require "conform"

    conform.setup {
        formatters_by_ft = {
            lua = { "stylua" },
            rust = { "rustfmt" },
            nix = { "alejandra" },
        },
    }

    vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*",
        callback = function(args)
            require("conform").format { bufnr = args.buf }
        end,
    })
end

return M

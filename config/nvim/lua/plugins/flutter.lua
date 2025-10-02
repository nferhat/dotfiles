-- Starting out in flutter dev.
local M = {
    'nvim-flutter/flutter-tools.nvim',
    lazy = false,
    dependencies = {
        'nvim-lua/plenary.nvim',
        'stevearc/dressing.nvim', -- optional for vim.ui.select
    },
}

M.config = function()
    local ft = require "flutter-tools"
    ft.setup {
        ui = { border = "solid" },
        widget_guides = { enabled = true },
        closing_guides = { highlight = "LspInlayHint", prefix = "   ->" },
        capabilities = require("blink.cmp").get_lsp_capabilities(),
    }
end

return M

-- Starting out in flutter dev.
local M = {
    'nvim-flutter/flutter-tools.nvim',
    ft = "dart",
    dependencies = { 'nvim-lua/plenary.nvim' },
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

local C = require "ui.theme.colors"

return {
    TelescopeNormal = { bg = "none", fg = C.on_background },
    TelescopeBorder = { bg = "none", fg = C.color17 },
    TelescopePreviewNormal = { bg = "none", fg = C.on_background },
    TelescopePreviewBorder = { bg = "none", fg = C.color17 },

    TelescopeSelection = { fg = C.color4, bg = "none", bold = true },
    TelescopeSelectionCaret = { fg = C.color4, bg = "none", bold = true },
    TelescopeMatching = { fg = C.color6, bold = true, italic = true },

    TelescopeMultiIcon = { fg = C.color1, bold = true },
    TelescopeMultiSelection = { fg = C.color3, bold = true },
    TelescopePromptCounter = C.on_surface_low,
    TelescopePreviewMessageFillchar = C.on_surface_low,
}

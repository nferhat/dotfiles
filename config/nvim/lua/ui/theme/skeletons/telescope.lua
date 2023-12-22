local C = require "ui.theme.colors"

return {
    TelescopeNormal = { bg = C.light_background, fg = C.foreground },
    TelescopeBorder = { bg = C.light_background, fg = C.border },
    TelescopePreviewNormal = { bg = C.dark_background, fg = C.foreground },
    TelescopePreviewBorder = { bg = C.dark_background, fg = C.border },

    TelescopeSelection = { bg = C.selection:brighten(1), fg = C.color4 },
    TelescopeSelectionCaret = { bg = C.selection:brighten(1), fg = C.color4 },
    TelescopeMatching = { fg = C.color6, bold = true, italic = true },

    TelescopeMultiIcon = { fg = C.color1, bold = true },
    TelescopeMultiSelection = { fg = C.color3, bold = true },
    TelescopePromptCounter = C.comment,
    TelescopePreviewMessageFillchar = C.comment,
}

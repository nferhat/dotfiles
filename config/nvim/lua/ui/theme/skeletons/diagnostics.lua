local C = require "ui.theme.colors"

return {
    DiagnosticError = { fg = C.color1, bold = true },
    DiagnosticWarn = { fg = C.color3, bold = true },
    DiagnosticInfo = { fg = C.color4, bold = true },
    DiagnosticHint = { fg = C.on_surface_low, bold = false },
    DiagnosticVirtualTextError = { fg = C.color1, bold = true },
    DiagnosticVirtualTextWarn = { fg = C.color3, bold = true },
    DiagnosticVirtualTextInfo = { fg = C.color4, bold = true },
    DiagnosticVirtualTextHint = { fg = C.on_surface_low, bold = false },
    DiagnosticUnderlineError = { sp = C.color1, undercurl = true },
    DiagnosticUnderlineWarn = { sp = C.color3, undercurl = true },
    DiagnosticUnderlineInfo = { sp = C.color4, undercurl = true },
    DiagnosticUnderlineHint = { sp = C.on_surface_low, undercurl = false },
}

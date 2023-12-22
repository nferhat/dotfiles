local C = require "ui.theme.colors"

return {
    DiagnosticError = { fg = C.color1, bold = true },
    DiagnosticWarn = { fg = C.color3, bold = true },
    DiagnosticInfo = { fg = C.color4, bold = true },
    DiagnosticHint = { fg = C.comment, bold = false },
    DiagnosticVirtualTextError = { bg = C.light_background:increase_red(4), fg = C.color1, bold = true },
    DiagnosticVirtualTextWarn = {
        bg = C.light_background:increase_red(4):increase_green(2),
        fg = C.color3,
        bold = true,
    },
    DiagnosticVirtualTextInfo = { bg = C.light_background:increase_blue(4), fg = C.color4, bold = true },
    DiagnosticVirtualTextHint = { bg = C.light_background, fg = C.comment, bold = false },
    DiagnosticUnderlineError = { sp = C.color1, undercurl = true },
    DiagnosticUnderlineWarn = { sp = C.color3, undercurl = true },
    DiagnosticUnderlineInfo = { sp = C.color4, undercurl = true },
    DiagnosticUnderlineHint = { sp = C.comment, undercurl = false },
}

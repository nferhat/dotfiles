local C = require "ui.theme.colors"

return {
    NoiceCmdlinePopupBorder = { link = "FloatBorder" },
    NoiceCmdlinePopupBorderCalculator = { link = "FloatBorder" },
    NoiceCmdlinePopupBorderCmdline = { link = "FloatBorder" },
    NoiceCmdlinePopupBorderFilter = { link = "FloatBorder" },
    NoiceCmdlinePopupBorderSearch = { link = "FloatBorder" },
    NoiceCmdlinePopupBorderInput = { link = "FloatBorder" },
    NoiceCmdlinePopupBorderLua = { link = "FloatBorder" },
    NoicePopupmenu = { link = "NormalFloat" },
    NoicePopupmenuBorder = { link = "FloatBorder" },
    NoicePopupmenuSelected = { bg = C.surface_bright },
    NoicePopupmenuMatch = { fg = C.color4, bold = true },
    NoiceScrollbar = { bg = "none", fg = C.background },
    NoiceScrollbarThumb = { bg = C.color0, fg = C.surface },
}

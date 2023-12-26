local C = require "ui.theme.colors"

return {
    MiniClueDescSingle = { bg = "none", fg = C.color4 },
    MiniClueDescGroup = { bg = "none", fg = C.color12, bold = true },
    MiniClueNextKey = { bg = "none", fg = C.color5 },
    MiniClueNextKeyWithPostkeys = { link = "MiniClueNextKey" },
    MiniClueSeparator = { bg = "none", fg = C.color17 },
    MiniClueTitle = { link = "Title" },
    MiniClueBorder = { link = "FloatBorder" },
}

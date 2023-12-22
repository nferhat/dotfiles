local C = require "ui.theme.colors"

local bg = C.light_background:brighten(1)

return {
    MiniClueDescSingle = { bg = bg, fg = C.color4 },
    MiniClueDescGroup = { bg = bg, fg = C.color12, bold = true },
    MiniClueNextKey = { bg = bg, fg = C.color5 },
    MiniClueNextKeyWithPostkeys = { link = "MiniClueNextKey" },
    MiniClueSeparator = { bg = bg, fg = C.border },
    MiniClueTitle = { bg = bg, fg = C.color4, bold = true },
    MiniClueBorder = { bg = bg },
}

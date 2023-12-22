local C = require "ui.theme.colors"

return {
    -- Status buffer.
    NeogitBranch = { fg = C.color4, italic = true },
    NeogitRemote = C.color11,
    NeogitObjectId = { fg = C.color3, italic = true },
    NeogitStash = C.comment,
    NeogitRebaseDone = C.color2,
    NeogitTagName = C.color3,
    -- Headers.
    NeogitCommitViewHeader = { bg = C.light_background, fg = C.color4, bold = true },
    -- Status buffer line and Highlight variants when we are seeing the context.
    NeogitHunkHeader = C.color4,
    NeogitHunkHeaderHighlight = { fg = C.color4, italic = true },
    NeogitDiffAdd = C.color2,
    NeogitDiffAddHighlight = { bg = C.selection, fg = C.color2 },
    NeogitDiffContext = C.comment:lighten(10),
    NeogitDiffContextHighlight = { link = "NeogitDiffContext" },
    NeogitDiffDelete = C.color1,
    NeogitDiffDeleteHighlight = { bg = C.light_background, fg = C.color1 },
}

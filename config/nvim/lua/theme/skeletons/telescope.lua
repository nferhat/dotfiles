local C = require("theme.colors")

return {
	TelescopeNormal = { fg = C.foreground, bg = "none" },
	TelescopeBorder = { fg = C.border, bg = "none" },

	TelescopeSelection = { bg = C.color8:decrease_green(0.5), fg = C.color4, bold = true },
	TelescopeSelectionCaret = { bg = C.selection, fg = C.color4 },
	TelescopeMatching = { fg = C.color9, bold = true, italic = false },

	TelescopeMultiIcon = { fg = C.color1, bold = true },
	TelescopeMultiSelection = { fg = C.color3, bold = true },
	TelescopePromptCounter = C.comment,
	TelescopePreviewMessageFillchar = C.comment,
	TelescopePreviewMessage = { fg = C.color7, bold = true },
}

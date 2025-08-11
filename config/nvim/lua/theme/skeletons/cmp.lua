local C = require("theme.colors")

local ENABLE_BG = vim.g.cmp_with_bg
local function bg(col)
	return ENABLE_BG and col or nil
end

return {
	-- The main menu
	BlinkCmpMenu = { bg = C.light_background },
	BlinkCmpMenuBorder = { link = "BlinkCmpMenu" },
	BlinkCmpLabelDetail = { bg = C.light_background, fg = C.comment:darken(5) },
	BlinkCmpLabel = C.foreground,
	BlinkCmpScrollBarThumb = { bg = C.border },
	BlinkCmpScrollBarGutter = { link = "BlinkCmpMenu" },
	BlinkCmpMenuSelection = { bold = true, bg = C.light_background:darken(2) },
	BlinkCmpLabelDeprecated = { strikethrough = true },
	BlinkCmpLabelMatch = C.color4,

	-- Client item kinds, the following are builtin to cmp.
	CmpItemAbbrDeprecated = { fg = C.color7, strikethrough = true },
	CmpItemAbbrMatchFuzzy = { link = "CmpItemAbbrMatch" },
	CmpItemAbbrMatch = { fg = C.color4, bold = true },
	BlinkCmpKindSnippet = { fg = C.color2, bg = bg(C.dark_background:increase_green(4)) },
	BlinkCmpKindConstant = { fg = C.color3, bg = bg(C.dark_background:increase_red(6):increase_green(4):brighten(4)) },
	BlinkCmpKindConstructor = C.color4,
	BlinkCmpKindEnum = { link = "BlinkCmpKindConstant" },
	BlinkCmpKindEnumMember = { link = "BlinkCmpKindConstant" },
	BlinkCmpKindEvent = { fg = C.color1, bg = bg(C.dark_background:increase_red(4)) },
	BlinkCmpKindInterface = { link = "BlinkCmpKindConstant" },
	BlinkCmpKindKeyword = { fg = C.color5, bg = bg(C.dark_background:increase_red(6):increase_blue(6)) },
	BlinkCmpKindClass = { link = "BlinkCmpKindConstant" },
	BlinkCmpKindModule = { link = "BlinkCmpKindEvent" },
	BlinkCmpKindOperator = C.comment,
	BlinkCmpKindTypeParameter = { link = "BlinkCmpKindConstant" },
	BlinkCmpKindUnit = { link = "BlinkCmpKindSnippet" },
	BlinkCmpKindField = { fg = C.color6, bg = bg(C.dark_background:increase_green(4):increase_blue(4):brighten(4)) },
	BlinkCmpKindVariable = { link = "BlinkCmpKindField" },
	BlinkCmpKindText = { fg = C.comment, bg = bg(C.light_background:darken(1)) },
	BlinkCmpKindFunction = { fg = C.color4, bg = bg(C.dark_background:increase_blue(2):brighten(4)) },
	BlinkCmpKindMethod = { link = "BlinkCmpKindFunction" },
	BlinkCmpKindProperty = { link = "BlinkCmpKindKeyword" },
	BlinkCmpKindFolder = { fg = "#f1d068" },
	BlinkCmpKindFile = { link = "BlinkCmpKindEvent" },
	BlinkCmpKindStruct = { link = "BlinkCmpKindConstant" },
}

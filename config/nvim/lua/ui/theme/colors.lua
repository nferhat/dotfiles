local colors = io.open("/home/nferhat/colors.json", "r")
local e = vim.json.decode(colors:read())

return vim.tbl_extend("force", {
    color0 = "#14161f",
    color1 = "#df5b61",
    color2 = "#87c7a1",
    color3 = "#de8f78",
    color4 = "#6791c9",
    color5 = "#bc83e3",
    color6 = "#70b9cc",
    color7 = "#c4c4c4",
    color8 = "#161922",
    color9 = "#ee6a70",
    color10 = "#96d6b0",
    color11 = "#ffb29b",
    color12 = "#7ba5dd",
    color13 = "#cb92f2",
    color14 = "#7fc8db",
    color15 = "#cccccc",
    color16 = "#434356", -- comments
    color17 = "#222230", -- misc details
}, e)

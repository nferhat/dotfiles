local C = require "ui.theme.colors"

return {
    TodoBgFix = {
        fg = C.color1,
        bg = C.background:mix(C.color1, 11.5),
    },
    TodoBgTodo = {
        fg = C.color4,
        bg = C.background:mix(C.color4, 11.5),
    },
    TodoBgHack = {
        fg = C.color3,
        bg = C.background:mix(C.color3, 11.5),
    },
    TodoBgWarn = {
        fg = C.color11,
        bg = C.background:mix(C.color11, 11.5),
    },
    TodoBgPerf = {
        fg = C.color9,
        bg = C.background:mix(C.color9, 11.5),
    },
    TodoBgNote = {
        fg = C.color12,
        bg = C.background:mix(C.color12, 11.5),
    },
    TodoBgTest = {
        fg = C.color2,
        bg = C.background:mix(C.color2, 11.5),
    },

    TodoFgFix = { fg = C.color1 },
    TodoFgTodo = { fg = C.color4 },
    TodoFgHack = { fg = C.color3 },
    TodoFgWarn = { fg = C.color11 },
    TodoFgPerf = { fg = C.color9 },
    TodoFgNote = { fg = C.color6 },
    TodoFgTest = { fg = C.color2 },

    TodoSignFix = { fg = C.color1 },
    TodoSignTodo = { fg = C.color4 },
    TodoSignHack = { fg = C.color3 },
    TodoSignWarn = { fg = C.color11 },
    TodoSignPerf = { fg = C.color9 },
    TodoSignNote = { fg = C.color6 },
    TodoSignTest = { fg = C.color2 },
}

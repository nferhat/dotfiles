local C = require "ui.theme.colors"

return {
    StatusLine_mode_Normal = { fg = C.color1, italic = true, bg = C.light_background:brighten(1.2) },
    StatusLine_mode_Insert = { fg = C.color2, italic = true, bg = C.light_background:brighten(1.2) },
    Statusline_mode_Terminal = { fg = C.color1, italic = true, bg = C.light_background:brighten(1.2) },
    Statusline_mode_Visual = { fg = C.color4, italic = true, bg = C.light_background:brighten(1.2) },
    Statusline_mode_Select = { fg = C.color3, italic = true, bg = C.light_background:brighten(1.2) },
    Statusline_mode_Command = { fg = C.color5, italic = true, bg = C.light_background:brighten(1.2) },
    Statusline_mode_Confirm = { fg = C.color6, italic = true, bg = C.light_background:brighten(1.2) },
    Statusline_mode_NTerminal = { link = "Statusline_mode_term", bold = true },

    Statusline_filetype_default = { bg = C.light_background, fg = C.color1 },
    Statusline_filetype_name = { bg = C.light_background, fg = C.foreground },

    Statusline_filename_normal = { bg = C.light_background, fg = C.foreground },
    Statusline_filename_modified = { bg = C.light_background, fg = C.color4 },
    Statusline_filename_readonly = { bg = C.light_background, fg = C.color1 },

    Statusline_lspclients = { bg = C.light_background, fg = C.color6, italic = true },
    Statusline_separator = { bg = C.light_background, fg = C.color0 },

    Statusline_git_branch_icon = { bg = C.light_background, fg = C.color5 },
    Statusline_git_diff_added = { bg = C.light_background, fg = C.color2 },
    Statusline_git_diff_changed = { bg = C.light_background, fg = C.color4 },
    Statusline_git_diff_removed = { bg = C.light_background, fg = C.color1 },

    Statusline_diagnostic_error = { fg = C.color1, bold = true, bg = C.light_background },
    Statusline_diagnostic_warn = { fg = C.color3, bold = true, bg = C.light_background },
    Statusline_diagnostic_info = { fg = C.color4, bold = true, bg = C.light_background },
    Statusline_diagnostic_hint = { fg = C.comment, bold = false, bg = C.light_background },

    Statusline_misc_text = { bg = C.light_background, fg = C.comment, italic = true },
    Statusline_text = { bg = C.light_background, fg = C.foreground },

    Statusline_project_dir = { bg = C.light_background:brighten(1.2), fg = C.color4 },
    Statusline_project_dir_sep = { bg = C.light_background:brighten(1.2), fg = C.hint },

    Statusline_linecol = { bg = C.light_background:brighten(1.2), fg = C.foreground },
}

local C = require "ui.theme.colors"

return {
    StatusLine_mode_Normal = { fg = C.color1, italic = true, bg = C.surface_container_high },
    StatusLine_mode_Insert = { fg = C.color2, italic = true, bg = C.surface_container_high },
    Statusline_mode_Terminal = { fg = C.color1, italic = true, bg = C.surface_container_high },
    Statusline_mode_Visual = { fg = C.color4, italic = true, bg = C.surface_container_high },
    Statusline_mode_Select = { fg = C.color3, italic = true, bg = C.surface_container_high },
    Statusline_mode_Command = { fg = C.color5, italic = true, bg = C.surface_container_high },
    Statusline_mode_Confirm = { fg = C.color6, italic = true, bg = C.surface_container_high },
    Statusline_mode_NTerminal = { link = "Statusline_mode_terminal", bold = true },

    Statusline_filetype_default = { bg = C.surface_container, fg = C.color1 },
    Statusline_filetype_name = { bg = C.surface_container, fg = C.on_surface },

    Statusline_filename_normal = { bg = C.surface_container, fg = C.on_surface },
    Statusline_filename_modified = { bg = C.surface_container, fg = C.color4 },
    Statusline_filename_readonly = { bg = C.surface_container, fg = C.color1 },

    Statusline_lspclients = { bg = C.surface_container, fg = C.color6, italic = true },
    Statusline_separator = { bg = C.surface_container, fg = C.color16 },

    Statusline_git_branch_icon = { bg = C.surface_container, fg = C.color5 },
    Statusline_git_diff_added = { bg = C.surface_container, fg = C.color2 },
    Statusline_git_diff_changed = { bg = C.surface_container, fg = C.color4 },
    Statusline_git_diff_removed = { bg = C.surface_container, fg = C.color1 },

    Statusline_diagnostic_error = { fg = C.color1, bold = true, bg = C.surface_container },
    Statusline_diagnostic_warn = { fg = C.color3, bold = true, bg = C.surface_container },
    Statusline_diagnostic_info = { fg = C.color4, bold = true, bg = C.surface_container },
    Statusline_diagnostic_hint = { fg = C.on_surface_low, bold = false, bg = C.surface_container },

    Statusline_misc_text = { bg = C.surface_container, fg = C.color16, italic = true },
    Statusline_text = { bg = C.surface_container, fg = C.on_surface },

    Statusline_linecol = { bg = C.surface_container_high, fg = C.on_surface },
}

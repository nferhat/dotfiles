local M = {}

local highlight_text = require("utils").highlight_text

M.mode_colors = {
    ["n"] = { "NOR", "Statusline_mode_Normal" },
    ["niI"] = { "NOR", "Statusline_mode_Normal" },
    ["niR"] = { "NOR", "Statusline_mode_Normal" },
    ["niV"] = { "NOR", "Statusline_mode_Normal" },
    ["no"] = { "NOR", "Statusline_mode_Normal" },
    ["i"] = { "INS", "Statusline_mode_Insert" },
    ["ic"] = { "INS (completion)", "Statusline_mode_Insert" },
    ["ix"] = { "INS completion", "Statusline_mode_Insert" },
    ["t"] = { "TER", "Statusline_mode_Terminal" },
    ["nt"] = { "TER", "Statusline_mode_NTerminal" },
    ["v"] = { "VIS", "Statusline_mode_Visual" },
    ["V"] = { "VIS", "Statusline_mode_Visual" },
    ["Vs"] = { "VIS", "Statusline_mode_Visual" },
    [""] = { "VIS", "Statusline_mode_Visual" },
    ["R"] = { "REP", "Statusline_mode_Replace" },
    ["Rv"] = { "VIS", "Statusline_mode_Replace" },
    ["s"] = { "SEL", "Statusline_mode_Select" },
    ["S"] = { "SEL", "Statusline_mode_Select" },
    [""] = { "SEL", "Statusline_mode_Select" },
    ["c"] = { "CMD", "Statusline_mode_Command" },
    ["cv"] = { "CMD", "Statusline_mode_Command" },
    ["ce"] = { "CMD", "Statusline_mode_Command" },
    ["r"] = { "PRT", "Statusline_mode_Confirm" },
    ["rm"] = { "MORE", "Statusline_mode_Confirm" },
    ["r?"] = { "CHK", "Statusline_mode_Confirm" },
    ["x"] = { "CHK", "Statusline_mode_Confirm" },
    ["!"] = { "SH!", "Statusline_mode_Terminal" },
}

---Returns the current mode that Neovim is on.
---@return string
M.mode = function()
    local mode = M.mode_colors[vim.api.nvim_get_mode().mode]
    local ret = highlight_text(mode[2], " " .. mode[1]:lower() .. " ")
    return ret
end

M.diagnostics = function()
    ---@diagnostic disable-next-line: deprecated
    if not rawget(vim, "lsp") or #vim.lsp.get_active_clients { bufnr = 0 } == 0 then
        return ""
    end

    local error_count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    local warning_count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    local info_count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })

    local errors, warnings, info = "", "", ""

    if error_count > 0 then
        errors = " "
            .. highlight_text("Statusline_diagnostic_error", "󰅚 ")
            .. highlight_text("Statusline_text", tostring(error_count))
    end
    if warning_count > 0 then
        warnings = " "
            .. highlight_text("Statusline_diagnostic_warn", " ")
            .. highlight_text("Statusline_text", tostring(warning_count))
    end

    if info_count > 0 then
        info = " "
            .. highlight_text("Statusline_diagnostic_info", " ")
            .. highlight_text("Statusline_text", tostring(info_count))
    end

    return errors .. warnings .. info
end

M.lspclients = function()
    if not rawget(vim, "lsp") then
        return ""
    end

    ---@diagnostic disable-next-line: deprecated
    local attached_clients = vim.lsp.get_active_clients { bufnr = vim.api.nvim_get_current_buf() }
    if #attached_clients == 0 then
        return ""
    end

    local attached_clients_name = {}
    for _, attached_client in ipairs(attached_clients) do
        table.insert(attached_clients_name, attached_client.name)
    end

    local ret = table.concat(attached_clients_name, ", ")

    return " " .. highlight_text("Statusline_lspclients", " ") .. highlight_text("Statusline_text", ret)
end

M.git_branch = function()
    if vim.o.columns < 100 or not vim.b.gitsigns_status_dict then
        return ""
    end
    local branch = vim.b.gitsigns_status_dict.head
    branch = branch == "" and "no branch?" or branch
    return highlight_text("Statusline_git_branch_icon", " ") .. highlight_text("Statusline_text", branch) .. " "
end

M.git_diff = function()
    if not vim.b.gitsigns_status_dict or vim.fn.expand == "%" then
        return ""
    end

    local added = highlight_text("Statusline_git_diff_added", "+" .. tostring(vim.b.gitsigns_status_dict.added))
    local changed = highlight_text("Statusline_git_diff_changed", "~" .. tostring(vim.b.gitsigns_status_dict.changed))
    local removed = highlight_text("Statusline_git_diff_removed", "-" .. tostring(vim.b.gitsigns_status_dict.removed))

    return highlight_text("Statusline_separator", "[")
        .. table.concat({ added, changed, removed }, " ")
        .. highlight_text("Statusline_separator", "]")
        .. " "
end

M.filename = function()
    local fname = vim.fn.expand "%:t"
    fname = fname == "" and "[scratch]" or fname
    local filepath = vim.fn.expand "%:~:.:h"
    filepath = filepath == "" and "" or filepath .. "/"
    local highlight = (vim.bo.modified and "Statusline_filename_modified")
        or (vim.bo.readonly and "Statusline_filename_readonly")
        or "Statusline_filename_normal"
    return highlight_text("Statusline_separator", " ")
        .. highlight_text("Statusline_misc_text", filepath)
        .. highlight_text(highlight, fname)
end

return M

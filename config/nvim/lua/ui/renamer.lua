-- credits to @Malace : https://www.reddit.com/r/neovim/comments/ql4iuj/rename_hover_including_window_title_and/
-- This is modified version of the above snippet

local M = {}

M.open = function()
    local currName = vim.fn.expand "<cword>" .. " "

    local win = require("plenary.popup").create(currName, {
        style = "minimal",
        title = "Renamer",
        borderchars = borderchars,
        relative = "cursor",
        borderhighlight = "FloatBorder",
        focusable = true,
        width = 50,
        height = 1,
        line = "cursor+2",
        col = "cursor-1",
    })

    vim.cmd "normal w"
    vim.cmd "startinsert"

    vim.keymap.set({ "i", "n" }, "<Esc>", "<cmd>stopinsert | q!<CR>", { noremap = true, buffer = 0, slient = true })
    vim.keymap.set({ "i", "n" }, "<CR>", function()
        vim.cmd.stopinsert()
        M.apply(currName, win)
    end, { noremap = true, buffer = 0, silent = true })
end

M.apply = function(curr, win)
    local newName = vim.trim(vim.fn.getline ".")
    vim.api.nvim_win_close(win, true)

    if #newName > 0 and newName ~= curr then
        local params = vim.lsp.util.make_position_params()
        params.newName = newName

        vim.lsp.buf_request(0, "textDocument/rename", params)
    end
end

return M

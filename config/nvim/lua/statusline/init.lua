-- Custom statusline, made from strach.
-- Inspired by the following posts and repos:
-- * https://nihilistkitten.me/nvim-lua-statusline/
-- * https://nuxsh.is-a.dev/blog/custom-nvim-statusline.html#orgd4999c7
-- * https://elianiva.my.id/post/neovim-lua-statusline/
-- * https://github.com/NvChad/ui (their custom statusline)
-- And other gists that I'm too lazy to cite here.

local M = {}

function M.draw()
    local comps = require "statusline.components"
    local highlight_text = comps.highlight_text
    -- To avoid components highlights bleeding into one another
    local stopper = highlight_text("Statusline", "")

    local statusline = table.concat({
        comps.mode(),
        comps.lspclients(),
        comps.diagnostics(),
        comps.filename(),
        highlight_text("Statusline", "%="),
        comps.macro(),
        comps.git_branch(),
        comps.git_diff(),
        comps.filetype(),
        highlight_text("Statusline_linecol", " %03.3l:%03.3c "),
    }, stopper)

    return statusline
end

return M

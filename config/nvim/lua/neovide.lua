local O = vim.opt

O.guifont = "monospace:h13"

-- Fancy effects for floating windows!
vim.g.neovide_floating_blur_amount_x = 5.0
vim.g.neovide_floating_blur_amount_y = 5.0
-- vim.g.neovide_floating_corner_radius = 0.5
-- Blur oooo!!
vim.g.neovide_floating_blur = true
O.winblend = 10
O.pumblend = 10

-- The default highlights set Normal guibg=None, since neovim runs in a terminal
-- If neovide handles it, set a background color to apply
local colors = require "theme.colors"
vim.api.nvim_set_hl(0, "Normal", {
    bg = "#" .. colors.background:HEX(),
    fg = "#" .. colors.foreground:HEX(),
})
-- Custom highlights for telescope
vim.api.nvim_set_hl(0, "TelescopeNormal", { link = "NormalFloat" })
vim.api.nvim_set_hl(0, "TelescopeBorder", { link = "FloatBorder" })

vim.g.neovide_opacity = 0.95

vim.g.neovide_scale_factor = 1.0
local change_scale_factor = function(delta)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + delta
end
vim.keymap.set("n", "<C-=>", function()
    change_scale_factor(0.1)
end)
vim.keymap.set("n", "<C-->", function()
    change_scale_factor(-0.1)
end)

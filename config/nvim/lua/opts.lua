local api, O = vim.api, vim.opt

-- Colorscheme, see theme/
vim.cmd.colorscheme "theme"

-- General options, up to preference, and strongly influenced by other
-- editors I used (Helix, Zed, ...)
O.compatible = false
O.autochdir = false
O.incsearch = true
O.hlsearch = true
O.ignorecase = true
O.smartcase = true
O.background = "dark"
O.termguicolors = true
O.wrap = false
O.scrolloff = 8
O.fillchars = { eob = " ", stl = " ", stlnc = " " }
O.number = true
O.relativenumber = true
O.cursorline = true
O.showtabline = 0
O.signcolumn = "yes"
O.laststatus = 3
O.pumheight = 16
O.showmode = false
O.mouse = "a"
O.undofile = true
O.tabstop = 4
O.softtabstop = 4
O.expandtab = true
O.shiftwidth = 4
O.autoindent = true
O.smartindent = false -- buggy
O.hidden = true
O.fdls = 9999 -- don't fold when opening buffers
O.timeoutlen = 200
O.colorcolumn = { 80, 100 } -- 80 for code, 100 for comments
-- O.shell = "/bin/zsh"
O.splitbelow = true
O.splitright = true
O.pumwidth = 20
O.guifont = "monospace:h10"
O.guicursor = "" -- keep blocky cursor
O.winborder = "solid" -- border for most popups, then filled in with theme
-- O.winblend = 7
-- O.pumblend = 7
O.shortmess:append "sIc" -- disable nvim intro + completion messages
O.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
O.list = true -- shows hidden stuff like tabs
O.whichwrap:append "<>[]hl" -- move to next/prev lines with hl
-- Custom in-house statusline
O.statusline = "%!v:lua.require('statusline').draw()"
-- O.cmdheight = 0
O.exrc = true
-- O.clipboard:append { "unnamed", "unnamedplus" } -- system clipboard
-- Advanced extui builtin, trying it out cause its kinda cool
require("vim._extui").enable {}

-- Keymaps, also strongly influenced by my preferences.

-- Overriding the vim.keymap.set function to enforce default settings.
-- Yes, I do know it's a bad idea to override core functions, but there isn't
-- a builtin way to set default options.
vim.keymap.set_backup = vim.keymap.set
---@param mode string|table
---@param lhs string
---@param rhs string|function
---@param opts table|nil
function vim.keymap.set(mode, lhs, rhs, opts) ---@diagnostic disable-line
    opts = opts or {}
    opts.silent = opts.silent ~= nil and opts.silent or true -- Why isn't this a default?
    vim.keymap.set_backup(mode, lhs, rhs, opts)
end

local set_keymap = vim.keymap.set

-- <Space> as leader, pretty classic choice.
vim.g.mapleader = " "
vim.g.maplocalleader = " "
-- set_keymap({ "n", "v", "o" }, "<Space>", "<nop>")
-- Window navigation made easier.
set_keymap("n", "<C-h>", "<C-w>h", { desc = "Window Left" })
set_keymap("n", "<C-j>", "<C-w>j", { desc = "Window Down" })
set_keymap("n", "<C-k>", "<C-w>k", { desc = "Window Up" })
set_keymap("n", "<C-l>", "<C-w>l", { desc = "Window Right" })
-- Terminal window navigation
set_keymap("t", "<C-x>", "<C-\\><C-N><Esc>", { desc = "Exit Terminal insert" })
set_keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", { desc = "Window Left" })
set_keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", { desc = "Window Down" })
set_keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", { desc = "Window Up" })
set_keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", { desc = "Window Right" })
-- Buffer actions
set_keymap("n", "<leader>x", ":bdelete!<CR>", { desc = "Close Buffer" })
set_keymap("n", "<leader>s", ":write!<CR>", { desc = "Save Buffer" })
-- Easier splits
set_keymap("n", "<leader>|", ":vsplit<CR>", { desc = "Vertical Split" })
set_keymap("n", "<leader>-", ":split<CR>", { desc = "Horizontal Split" })
-- Stop matching for patterns
set_keymap("n", "<Esc>", ":nohlsearch<CR>")
-- Allow moving through wrapped lines without using g{j,k}
set_keymap("n", "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
set_keymap("n", "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })
set_keymap("n", "<Down>", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
set_keymap("n", "<Up>", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })
-- Easier indenting.
set_keymap("n", ">", ">>", { desc = "Indent to the Left" })
set_keymap("n", "<", "<<", { desc = "Indent to the Right" })
set_keymap({ "v", "x" }, "<", "<gv", { desc = "Indent to the Left" })
set_keymap({ "v", "x" }, ">", ">gv", { desc = "Indent to the Right" })
-- Don't put deleted text from x into clipboard.
set_keymap("n", "x", '"_x', { noremap = false })
-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
set_keymap("n", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
set_keymap("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
set_keymap("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
set_keymap("n", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
set_keymap("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
set_keymap("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
-- Keep vim clipboard separate from actual system clipboard
set_keymap({ "n", "x" }, "<leader>p", [["+p]], { desc = "Paste from system clipboard" })
set_keymap({ "n", "x" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })

-- Stop the cursor from going back when exiting insert mode
set_keymap("i", "<Esc>", "<Esc>`^", { noremap = true })
O.virtualedit = "onemore"

-- Autocommands
-- Some stuff that editors do automatically but not present in neovim
-- Don't pollute the global autogroup namespace
local fht = api.nvim_create_augroup("fht", { clear = true })

api.nvim_create_autocmd({ "BufWritePre" }, {
    desc = "Trim Trailing whitespace from buffers",
    group = fht,
    pattern = "*",
    callback = function()
        local view = vim.fn.winsaveview()
        vim.cmd [[keeppatterns %s/\s\+$//e]]
        vim.fn.winrestview(view)
    end,
})

api.nvim_create_autocmd({ "VimResized" }, {
    desc = "Fixes Window sizes when Neovim terminal gets resized",
    group = fht,
    callback = function()
        vim.cmd.tabdo "wincmd ="
        vim.cmd.redraw()
    end,
})

api.nvim_create_autocmd({ "TextYankPost" }, {
    desc = "Highlight on yank",
    group = fht,
    callback = function()
        vim.highlight.on_yank { higroup = "Visual", timeout = 300 }
    end,
})

api.nvim_create_autocmd({ "FocusGained" }, {
    desc = "More eager checking for files changes outside Neovim",
    group = fht,
    command = "checktime",
})

api.nvim_create_autocmd({ "BufEnter" }, {
    desc = "Settings for terminal buffers ",
    pattern = { "terminal", "term://*" },
    group = fht,
    command = "set nonumber norelativenumber signcolumn=yes",
})

-- User event that loads after UIEnter + only if file buf is there
-- Borrowed from NvChad
api.nvim_create_autocmd({ "UIEnter", "BufReadPost", "BufNewFile" }, {
    group = vim.api.nvim_create_augroup("NvFilePost", { clear = true }),
    callback = function(args)
        local file = vim.api.nvim_buf_get_name(args.buf)
        local buftype = vim.api.nvim_get_option_value("buftype", { buf = args.buf })

        if not vim.g.ui_entered and args.event == "UIEnter" then
            vim.g.ui_entered = true
        end

        if file ~= "" and buftype ~= "nofile" and vim.g.ui_entered then
            vim.api.nvim_exec_autocmds("User", { pattern = "FilePost", modeline = false })
            vim.api.nvim_del_augroup_by_name "NvFilePost"

            vim.schedule(function()
                vim.api.nvim_exec_autocmds("FileType", {})

                if vim.g.editorconfig then
                    require("editorconfig").config(args.buf)
                end
            end)
        end
    end,
})

-- Additional config for Neovide
-- As per docs, g:neovide must be set to run these
if vim.g.neovide then
    require "neovide"
end

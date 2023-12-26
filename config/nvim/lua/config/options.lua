local O = vim.opt

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
O.shell = os.getenv("SHELL") or "/bin/sh"
O.splitbelow = true
O.splitright = true
O.pumwidth = 20
O.guifont = "monospace:h10"
O.shortmess:append "sIc" -- disable nvim intro + completion messages
O.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
O.list = true -- shows hidden stuff like tabs
O.whichwrap:append "<>[]hl" -- move to next/prev lines with hl
O.winblend = 10
-- O.clipboard:append { "unnamed", "unnamedplus" } -- system clipboard

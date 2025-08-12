-- Git commit files are pretty interesting
--
-- There's quite a lot of etiquette around how you should type and format in the
-- commit buffer/message. Tim Pope's blogpost is pretty good at explainng this
-- https://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html

-- This buffer will only be used for typing in insert mode, I don't need the
-- numberline to guide my jumps at all
vim.opt_local.number = false
vim.opt_local.relativenumber = false
-- Spelling is obvious, would be pretty embarassing...
vim.opt_local.spell = true
-- I know that neovim automatically wraps around for me, but having a visual
-- indicator is always nice
vim.opt.colorcolumn = { 50, 72 }

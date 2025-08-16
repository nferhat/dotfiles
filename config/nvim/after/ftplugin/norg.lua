-- Neorg similar to markdown is a markup language
--
-- Disable numbering since I will be typing a lot, instead of jumping around
-- doing stuff
vim.opt_local.number = false
vim.opt_local.relativenumber = false
vim.opt_local.wrap = true -- the only time I can support wrapping in my editor
vim.opt_local.foldlevel = 99
-- Norg itself has a core.conceal module that will change stuff to diamonds and
-- cool shapes But this conceals even more stuff, like links, font style markers
-- etc.
vim.opt_local.conceallevel = 2

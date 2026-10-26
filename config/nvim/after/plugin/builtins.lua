-- builtins.lua -*- configure builtin neovim plugins.

-- editorconfig (https://editorconfig.org) is a standard file you add in a project to configure
-- stuff like indent size and line endings. Autoload them after being done with after/ftplugin
vim.cmd.packadd 'editorconfig'

-- export nice previews of my code.
vim.cmd.packadd 'nvim.tohtml'

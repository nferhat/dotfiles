require "global"
require "config.options"

local providers = { "python", "node", "ruby", "perl" }
for _, provider in pairs(providers) do
    vim.g["loaded_" .. provider .. "_provider"] = 0
end

require "config.keymaps"
require "config.autocommands"

local lazy_path = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazy_path) then
    print "Installing lazy.nvim..."
    vim.fn.system {
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim",
        "--branch=stable",
        lazy_path,
    }
end

vim.opt.runtimepath:prepend(lazy_path)
require("lazy").setup("plugins", {
    defaults = { lazy = true },
    ui = { border = "single" },
    install = { colorscheme = { "theme" } },
    profiling = { loader = true, require = true },
    performance = {
        cache = { enabled = true },
        rtp = {
            disabled_plugins = {
                "2html_plugin",
                "tohtml",
                "getscript",
                "getscriptPlugin",
                "gzip",
                "logipat",
                "netrw",
                "netrwPlugin",
                "netrwSettings",
                "netrwFileHandlers",
                "matchit",
                "tar",
                "tarPlugin",
                "rrhelper",
                "spellfile_plugin",
                "vimball",
                "vimballPlugin",
                "zip",
                "zipPlugin",
                "tutor",
                "rplugin",
                "syntax",
                "synmenu",
                "optwin",
                "compiler",
                "bugreport",
                "ftplugin",
                "editorconfig",
            },
        },
    },
})

require("ui.theme").init()
require("ui.statusline").init()

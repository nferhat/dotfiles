-- treesitter.lua -*- install parsers
-- FIXME: Use package manager

vim.api.nvim_create_autocmd({ 'User' }, {
    pattern = 'FilePost',
    once = true,
    callback = function()
        vim.pack.add { {
            src = 'https://github.com/nvim-treesitter/nvim-treesitter',
            version = 'main',
        } }

        require('nvim-treesitter').setup {
            highlight = { enable = true, use_languagetree = true },
            indent = { enable = true },
        }
    end
})

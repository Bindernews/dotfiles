
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
    -- Have packer manage itself
    use 'wbthomason/packer.nvim'
    -- Tree view
    use {
        'kyazdani42/nvim-tree.lua',
        requires = {
            'kyazdani42/nvim-web-devicons',
        },
        tag = 'nightly',
    }
    -- Nightfox color scheme
    use { "EdenEast/nightfox.nvim", tag = "v1.0.0" }
    -- https://github.com/TimUntersberger/neogit
    use { 'TimUntersberger/neogit', requires = 'nvim-lua/plenary.nvim' }
end)


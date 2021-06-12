return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    use 'astridlyre/falcon'
    use 'hoob3rt/lualine.nvim'
    use 'norcalli/nvim-colorizer.lua'
    use 'camspiers/snap'
    use 'junegunn/vim-easy-align'
    use 'b3nj5m1n/kommentary'
    use 'tpope/vim-fugitive'
    use 'nvim-lua/plenary.nvim'
    use 'lewis6991/gitsigns.nvim'
    use 'nvim-treesitter/nvim-treesitter'
    use 'nvim-treesitter/nvim-treesitter-textobjects'
    use 'RRethy/nvim-treesitter-textsubjects'
    use 'windwp/nvim-ts-autotag'
    use 'andymass/vim-matchup'
    use 'neovim/nvim-lspconfig'
    use 'hrsh7th/nvim-compe'
    use 'windwp/nvim-autopairs'
    use 'ray-x/lsp_signature.nvim'
    use 'hrsh7th/vim-vsnip'
    use 'hrsh7th/vim-vsnip-integ'
    use 'rafamadriz/friendly-snippets'

    -- Load modules
    local modules = {
        require('ml-completion'), require('ml-ui'), require('ml-treesitter'),
        require('lsp')
    }
    for _, m in pairs(modules) do for _, config in pairs(m) do config() end end

end)

return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    local ui = require('ml-ui')
    use {'astridlyre/falcon', config = vim.cmd('colorscheme falcon')}
    use {'hoob3rt/lualine.nvim', config = ui.lualine()}
    use {'norcalli/nvim-colorizer.lua', config = ui.colorizer()}
    use {'camspiers/snap', rocks = {'fzy'}}
    use 'junegunn/vim-easy-align'
    use 'b3nj5m1n/kommentary'
    use 'tpope/vim-fugitive'

    local ts = require('ml-treesitter')
    use {'lewis6991/gitsigns.nvim', requires = {'nvim-lua/plenary.nvim'}}
    use {'nvim-treesitter/nvim-treesitter', config = ts.configure()}
    use 'nvim-treesitter/nvim-treesitter-textobjects'
    use 'RRethy/nvim-treesitter-textsubjects'
    use 'andymass/vim-matchup'
    use 'windwp/nvim-ts-autotag'

    local lsp = require('lsp')
    use {'neovim/nvim-lspconfig', config = lsp.configure()}

    local completion = require('ml-completion')
    use {'hrsh7th/nvim-compe', config = completion.compe()}
    use {'ray-x/lsp_signature.nvim', config = completion.lsp_signature()}
    use {'windwp/nvim-autopairs', config = completion.autopairs()}
    use {
        'hrsh7th/vim-vsnip',
        requires = {'hrsh7th/vim-vsnip-integ', 'rafamadriz/friendly-snippets'}
    }
end)

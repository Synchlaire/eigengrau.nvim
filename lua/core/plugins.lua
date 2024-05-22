-- Ensure lazy.nvim is installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Lazy.nvim setup
require("lazy").setup({

  -- Utility plugins
  { 'nvim-lua/plenary.nvim' },
  { 'nvim-tree/nvim-web-devicons' },
  { 'nacro90/numb.nvim' },
  { 'm4xshen/autoclose.nvim' },
  { 'stevearc/oil.nvim' },
  { 'xiyaowong/transparent.nvim' },
  { 'kkharji/sqlite.lua' },
  { 'sindrets/winshift.nvim' },
  { 'tpope/vim-repeat' },
  { 'tpope/vim-sensible' },
  { 'numToStr/comment.nvim' },
  { 'kylechui/nvim-surround' },
  { 'godlygeek/tabular' },
  { 'tmillr/sos.nvim' },
  { 'ap/vim-css-color' },
  { 'typicode/bg.nvim' },
  { 'reedes/vim-pencil' },
  { 'ecthelionvi/NeoComposer.nvim' },
  { 'konfekt/vim-office' },

  -- Navigation and search
  { 'ggandor/leap.nvim' },
  { 'ggandor/flit.nvim' },
  { 'sidebar-nvim/sidebar.nvim' },
  { 'folke/which-key.nvim' },

  -- Obsidian and markdown plugins

  { 'epwalsh/obsidian.nvim' },
  { 'meanderingprogrammer/markdown.nvim', name = 'render-markdown'},
  { "tadmccorkle/markdown.nvim", ft = "markdown"},
  { 'oflisback/obsidian-bridge.nvim'},

  -- Telescope plugins
  { 'nvim-telescope/telescope.nvim' },
  { 'nvim-telescope/telescope-frecency.nvim' },
  { '2kabhishek/nerdy.nvim' },
  { 'keyvchan/telescope-find-pickers.nvim' },
  { 'ghassan0/telescope-glyph.nvim' },


  -- Git integration
  { 'airblade/vim-gitgutter' },

  -- Tree-sitter for better syntax highlighting
  { 'nvim-treesitter/nvim-treesitter' },

  -- LSP and Autocompletion
  { 'onsails/lspkind.nvim' },
  { 'VonHeikemen/lsp-zero.nvim', branch = 'v1.x', dependencies = {
    'neovim/nvim-lspconfig',
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-nvim-lua',
    'f3fora/cmp-spell',
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
    'rafamadriz/friendly-snippets',
  }},

  -- Debugging and diagnostics
  { 'mfussenegger/nvim-dap' },
  { 'folke/trouble.nvim', dependencies = 'nvim-tree/nvim-web-devicons' },

  -- Better UI
  { 'folke/noice.nvim', dependencies = {
    'MunifTanjim/nui.nvim',
    'rcarriga/nvim-notify',
  }},
  { 'anuvyklack/windows.nvim', dependencies = {
    'anuvyklack/middleclass',
    'anuvyklack/animation.nvim',
  }},
  -- Status line
  { 'nvim-lualine/lualine.nvim', dependencies = {
    'meuter/lualine-so-fancy.nvim',
    'nativerv/lualine-wal.nvim',
  }},

  -- Modes
--  { 'mvllow/modes.nvim' },
  { 'gen740/SmoothCursor.nvim' }, --better cursor

  -- Terminal integration
  { 'akinsho/toggleterm.nvim', config = function() require("toggleterm").setup() end},

  -- Colorschemes
  { 'uZer/pywal16.nvim', branch = 'newcolors', name = 'pywal16' },
  { 'erdivartanovich/pywal.nvim', name ='wal' },
  { 'nyoom-engineering/oxocarbon.nvim' },
  { 'fxn/vim-monochrome' },
  { 'olivercederborg/poimandres.nvim' },
  { 'danishprakash/vim-yami' },
  { 'andreypopp/vim-colors-plain' },
  { 'kvrohit/substrata.nvim' },
  { 'rockerBOO/boo-colorscheme-nvim' },
  { 'lamartire/hg.vim' },
  { 'sts10/vim-pink-moon' },
  { 'kartikp10/noctis.nvim' },
  { 'fynnfluegge/monet.nvim' },
  { 'mcchrish/zenbones.nvim', dependencies = 'rktjmp/lush.nvim' },
  { 'craftzdog/solarized-osaka.nvim' },
  { 'sainnhe/everforest' },
  { 'relastle/bluewery.vim' },
  { 'haishanh/night-owl.vim' },
  { 'bluz71/vim-nightfly-colors', name = 'nightfly' },
  { 'lunarvim/templeos.nvim' },

})

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
  { 'stevearc/oil.nvim', event = "VeryLazy"},
  { 'xiyaowong/transparent.nvim' },
  { 'kkharji/sqlite.lua', event = "VeryLazy" },
  { 'sindrets/winshift.nvim', event = "VeryLazy" },
  { 'tpope/vim-repeat' },
  { 'tpope/vim-sensible' },
  { 'numToStr/comment.nvim', event = "VeryLazy"},
  { 'kylechui/nvim-surround' },
  { 'godlygeek/tabular', event = "VeryLazy" },
  { 'tmillr/sos.nvim' },
  { 'typicode/bg.nvim' },
  { 'ecthelionvi/NeoComposer.nvim' },
  { 'konfekt/vim-office', event = "VeryLazy"},

  -- Navigation and search
  { 'ggandor/leap.nvim' },
  { 'ggandor/flit.nvim' },
  { 'sidebar-nvim/sidebar.nvim', event = "VeryLazy"},
  { 'folke/which-key.nvim' },
  { 'folke/flash.nvim' },

  -- Obsidian and markdown plugins

  { 'epwalsh/obsidian.nvim', event = "VeryLazy"},
  { 'meanderingprogrammer/markdown.nvim', ft = "markdown", name = 'render-markdown', event = "VeryLazy"},
  { "tadmccorkle/markdown.nvim", ft = "markdown", event = "VeryLazy"},
  { 'oflisback/obsidian-bridge.nvim', ft = "markdown", event = "VeryLazy" },
  {'dhruvasagar/vim-table-mode', ft = "markdown", event = "VeryLazy"},
  { 'reedes/vim-pencil', ft = "markdown", event = "VeryLazy",
    },
  -- Telescope plugins
  { 'nvim-telescope/telescope.nvim' },
  { 'nvim-telescope/telescope-frecency.nvim' },
  { '2kabhishek/nerdy.nvim', event = "VeryLazy" },
  { 'keyvchan/telescope-find-pickers.nvim', event = "VeryLazy" },
  { 'ghassan0/telescope-glyph.nvim', event = "VeryLazy" },


  -- Git integration
  { 'airblade/vim-gitgutter' },

  -- Tree-sitter for better syntax highlighting
  { 'nvim-treesitter/nvim-treesitter' },

  -- LSP and Autocompletion
  { 'onsails/lspkind.nvim' },
  { 'VonHeikemen/lsp-zero.nvim', branch = 'v1.x', event = "VeryLazy", dependencies = {
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
  { 'mfussenegger/nvim-dap', event = "VeryLazy" },
  { 'folke/trouble.nvim', dependencies = 'nvim-tree/nvim-web-devicons' },

  -- Better UI
  { 'folke/noice.nvim', dependencies = {
    'MunifTanjim/nui.nvim',
    'rcarriga/nvim-notify', }
 },

  { 'lukas-reineke/indent-blankline.nvim', main = "ibl"},
  { 'folke/todo-comments.nvim'},
  { 'anuvyklack/windows.nvim', event = "VeryLazy", dependencies = {
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
  {'folke/zen-mode.nvim', event = "VeryLazy"}, --zen mode

  -- Colorschemes
--  { 'uZer/pywal16.nvim', branch = 'newcolors', name = 'pywal16' },
  { 'erdivartanovich/pywal.nvim', name ='wal' },
  { 'nyoom-engineering/oxocarbon.nvim', event = "VeryLazy" },
  { 'olivercederborg/poimandres.nvim', event = "VeryLazy" },
  { 'andreypopp/vim-colors-plain', event = "VeryLazy" },
  { 'lamartire/hg.vim', event = "VeryLazy" },
  { 'sts10/vim-pink-moon', event = "VeryLazy" },
  { 'fynnfluegge/monet.nvim', event = "VeryLazy" },
  { 'craftzdog/solarized-osaka.nvim', event = "VeryLazy" },
  { 'relastle/bluewery.vim', event = "VeryLazy" },
  { 'haishanh/night-owl.vim', event = "VeryLazy" },
  { 'bluz71/vim-nightfly-colors', name = 'nightfly', },
--  { 'lunarvim/templeos.nvim', event = "VeryLazy"},
  { 'talha-akram/noctis.nvim', event = "VeryLazy"},

})



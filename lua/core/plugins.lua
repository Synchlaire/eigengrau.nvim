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
  { 'nacro90/numb.nvim', event = "CmdlineEnter" },
  { 'm4xshen/autoclose.nvim', event = "InsertEnter"},
  { 'stevearc/oil.nvim', event = "VeryLazy"},
  { 'xiyaowong/transparent.nvim', event = "VeryLazy" },
  { 'kkharji/sqlite.lua', event = "VeryLazy" },
  { 'sindrets/winshift.nvim', event = "VeryLazy" },
  { 'numToStr/comment.nvim', event = "VeryLazy"},
  { 'kylechui/nvim-surround' },
  { 'godlygeek/tabular', cmd = "Tabularize" },
  { 'tmillr/sos.nvim' },
  { 'typicode/bg.nvim' },
  { 'ecthelionvi/NeoComposer.nvim', event = "VeryLazy" },
  { 'konfekt/vim-office', ft = "markdown"},
  { 'folke/which-key.nvim', event = "VeryLazy"},
  -- Navigation and search
--  { 'ggandor/leap.nvim' },
--  { 'ggandor/flit.nvim' },
  { 'folke/flash.nvim' },
  { 'brenoprata10/nvim-highlight-colors', lazy = "true" },

  -- Obsidian and markdown plugins

  { 'epwalsh/obsidian.nvim', event = "VeryLazy"},
  { 'meanderingprogrammer/markdown.nvim', ft = "markdown", name = 'render-markdown',},
  { "tadmccorkle/markdown.nvim", ft = "markdown"},
  { 'oflisback/obsidian-bridge.nvim', cmd = "ObsidianQuickSwitch" },
  { 'dhruvasagar/vim-table-mode', ft = "markdown" },
  { 'reedes/vim-pencil', ft = "markdown"},

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
  { 'onsails/lspkind.nvim', event = "InsertEnter" },
  { 'VonHeikemen/lsp-zero.nvim', branch = 'v1.x', event = "InsertEnter", dependencies = {
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
  { 'mfussenegger/nvim-dap', event = "InsertEnter" },
  { 'folke/trouble.nvim', cmd = "Trouble", dependencies = 'nvim-tree/nvim-web-devicons' },

  -- Better UI
  { 'folke/noice.nvim', event = "VeryLazy", dependencies = {
    'MunifTanjim/nui.nvim',
    'rcarriga/nvim-notify', }
 },

  { 'lukas-reineke/indent-blankline.nvim', main = "ibl"},
  { 'folke/todo-comments.nvim'},
  { 'anuvyklack/windows.nvim', event = "WinNew", dependencies = {
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
  { 'gen740/SmoothCursor.nvim', event = "VeryLazy" }, --better cursor
  {'folke/zen-mode.nvim', lazy = true}, --zen mode


  -- Colorschemes
--  { 'uZer/pywal16.nvim', branch = 'newcolors', name = 'pywal16' },
  { 'erdivartanovich/pywal.nvim', name ='wal' },
--  { 'nyoom-engineering/oxocarbon.nvim', event = "Colorscheme" },
--  { 'olivercederborg/poimandres.nvim', event = "Colorscheme" },
  { 'andreypopp/vim-colors-plain', event = "Colorscheme" },
--  { 'lamartire/hg.vim', event = "Colorscheme" },
--  { 'sts10/vim-pink-moon', event = "Colorscheme" },
--  { 'fynnfluegge/monet.nvim', event = "Colorscheme" },
--  { 'craftzdog/solarized-osaka.nvim', event = "Colorscheme" },
--  { 'relastle/bluewery.vim', event = "Colorscheme" },
--  { 'haishanh/night-owl.vim', event = "Colorscheme" },
  { 'bluz71/vim-nightfly-colors', name = 'nightfly', },
--  { 'lunarvim/templeos.nvim', event = "VeryLazy"},
--  { 'talha-akram/noctis.nvim', event = "Colorscheme"},

})


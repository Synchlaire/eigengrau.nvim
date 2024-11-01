return {
  { "nvim-lua/plenary.nvim", event = "VimEnter" },
  { "nvim-tree/nvim-web-devicons", lazy = true },
  { "godlygeek/tabular", lazy = true, cmd = "Tabularize" },
  { "typicode/bg.nvim" },
  { "airblade/vim-gitgutter", lazy = true, event = "BufAdd" },
  { "tpope/vim-repeat" },
  {
    "konfekt/vim-office",
    lazy = true,
    ft = { "doc", "docx", "odt", "ppt", "pptx", "xls", "xlsx" },
  },

  {
    "max397574/better-escape.nvim",
    lazy = true,
    event = { "InsertEnter" },
    config = function()
      require("better_escape").setup {
	default_mappings = false,
	mappings = { --note: these can also be functions
	  i = {
	    j = {
	      k = "<Esc>"
	    },
	    k = {
	      j = "<Esc>"
	    },
	  },
	  t = {
	    j = {
	      k = "<C-\\><C-n>",
	    },
	  },
	  v = {
	    v = {
	      v = "<Esc>"
	    },
	  },
	  s = {
	    j = {
	      k = "<Esc>",
	    },
	  },
	}
      }
    end,
  }
}

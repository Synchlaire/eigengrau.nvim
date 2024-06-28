return{
  { "nvim-lua/plenary.nvim", event = "VimEnter" },
  { "nvim-tree/nvim-web-devicons", lazy = true },
  { "godlygeek/tabular", cmd = "Tabularize" },
  { "typicode/bg.nvim", event = "VimEnter" },
  {
    "konfekt/vim-office",
    lazy = true,
    ft = { "doc", "docx", "odt", "ppt", "pptx", "xls", "xlsx" },
  },
  { "airblade/vim-gitgutter", event = "BufEnter" },

  -- Debugging and diagnostics
  --	{ "mfussenegger/nvim-dap", event = "InsertEnter" },
}

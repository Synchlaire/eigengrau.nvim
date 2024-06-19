return {
    { 'nvim-lua/plenary.nvim' },
    { 'nvim-tree/nvim-web-devicons' },
    { 'xiyaowong/transparent.nvim', cmd = "TransparentToggle" },
    { 'kkharji/sqlite.lua', event = "VeryLazy" },
    { 'nvim-tree/nvim-web-devicons' },
    { 'numToStr/comment.nvim', event = "VeryLazy"},
    { 'godlygeek/tabular', cmd = "Tabularize" },
    { 'typicode/bg.nvim' },
    { 'konfekt/vim-office',
        ft = { "doc", "docx", "odt", "ppt", "pptx","xls", "xlsx" }
    },
    { 'dhruvasagar/vim-table-mode', ft = "markdown" },
{ 'airblade/vim-gitgutter', event = "BufEnter" },

  -- Debugging and diagnostics
  { 'mfussenegger/nvim-dap', event = "InsertEnter" },
  { 'folke/trouble.nvim', cmd = "Trouble", dependencies = 'nvim-tree/nvim-web-devicons' },
}

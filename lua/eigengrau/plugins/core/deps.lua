-- Core dependencies that must load at startup
return {
  { "nvim-lua/plenary.nvim", event = "VimEnter" },
  { "nvim-tree/nvim-web-devicons", lazy = false },
  { "tpope/vim-repeat" },
  { "typicode/bg.nvim", enabled = not vim.g.neovide },
}

-- Essential plugins that load early
return {
  -- Better escape from insert mode
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup({
        default_mappings = false,
        mappings = {
          i = {
            j = { k = "<Esc>" },
            k = { j = "<Esc>" },
          },
          t = {
            [" "] = { [" "] = "<C-\\><C-n>" },
          },
          v = {
            v = { v = "<Esc>" },
          },
          s = {
            j = { k = "<Esc>" },
          },
        },
      })
    end,
  },

  -- Auto pairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },

  -- Text alignment
  {
    "godlygeek/tabular",
    cmd = "Tabularize",
  },

  -- Sort utility
  {
    "sQVe/sort.nvim",
    cmd = "Sort",
  },

  -- Office file support
  {
    "konfekt/vim-office",
    ft = { "doc", "docx", "odt", "ppt", "pptx", "xls", "xlsx" },
  },
}

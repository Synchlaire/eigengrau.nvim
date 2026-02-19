return {
  "dmtrKovalenko/fff.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  build = function()
    require("fff.download").download_or_build_binary()
  end,
  cmd = { "FFFFind", "FFFScan", "FFFRefreshGit", "FFFHealth", "FFFClearCache" },
  keys = {
    { "<leader>ff", "<cmd>FFFFind<cr>",   desc = "Find Files" },
    { "<leader>fF", "<cmd>FFFFind ~<cr>", desc = "Find Files (Home)" },
  },
  config = function()
    require("fff").setup({
      prompt = "> ",
      max_results = 100,
      lazy_sync = true,
      keymaps = {
        move_up = { "<Up>", "<C-p>", "<C-k>" },
        move_down = { "<Down>", "<C-n>", "<C-j>" },
      },
    })
  end,
}

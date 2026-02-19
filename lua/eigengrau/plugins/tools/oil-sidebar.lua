return {
  "maelwalser/oil-bar.nvim",
  lazy = true,
  dependencies = { "stevearc/oil.nvim" },
  keys = {
    { "<leader>-", function() require("oil-bar.core").toggle() end, desc = "Toggle Sidebar" },
  },
  opts = {},
}

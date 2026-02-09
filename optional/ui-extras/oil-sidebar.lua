return {
  "maelwalser/oil-bar.nvim",
  lazy = true,
  dependencies = { "stevearc/oil.nvim" },
    keys = {
      { "<leader>-",  desc = "Toggle Sidebar" },
    },
  opts = {
    keymap = "<leader>-" -- Uncomment and change to your preferred key
  },
}

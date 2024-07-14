return {
  "NeogitOrg/neogit",
  lazy = true,
  cmd = "Neogit",
  dependencies = { "nvim-lua/plenary.nvim" },  -- required
  keys = {
    { "<leader>ng", "<cmd>Neogit<cr>", desc = "Neogit" },
  },
  opts = {},
  config = function(_, opts)
    require("neogit").setup(opts)
  end

}







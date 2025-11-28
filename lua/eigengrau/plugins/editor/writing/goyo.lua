-- Distraction-free writing with Goyo
return {
  -- Goyo: Distraction-free writing
  {
    "junegunn/goyo.vim",
    cmd = "Goyo",
    init = function()
      vim.g.goyo_width = 88
    end,
    keys = {
      { "<leader>zz", "<cmd>Goyo<CR>", desc = "Toggle Goyo" },
    },
  },

  -- Limelight: Focus on current section
  {
    "junegunn/limelight.vim",
    cmd = "Limelight",
    keys = {
      { "<leader>zl", "<cmd>Limelight!!<CR>", desc = "Toggle Limelight" },
    },
  },

  -- Twilight: Treesitter-based dimming
  {
    "folke/twilight.nvim",
    cmd = "Twilight",
    keys = {
      { "<leader>zt", "<cmd>Twilight<CR>", desc = "Toggle Twilight" },
    },
    opts = {
      dimming = {
        alpha = 0.25,
        color = { "Normal", "#ffffff" },
        term_bg = "#000000",
        inactive = true,
      },
      context = 1,
      treesitter = true,
      expand = {
        "function",
        "method",
        "table",
        "if_statement",
      },
      exclude = {},
    },
  },
}

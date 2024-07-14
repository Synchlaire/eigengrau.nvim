return {
  {
    "jlanzarotta/bufexplorer",
    -- To load the plugin at startup, I set lazy to false
    lazy = true,
    config = function()
      vim.g.bufExplorerShowRelativePath = 1
    end,
    -- In case you want to add keymaps, I probably won't use this one, but
    -- leaving it there
    keys = {
      {
        "<leader><tab>",
        "<cmd>BufExplorer<cr>",
        desc = "Open bufexplorer",
      },
      -- {
      --   "<S-h>",
      --   "<cmd>BufExplorer<cr>",
      --   mode = "n",
      --   desc = "Open bufexplorer",
      -- },
      -- {
      --   "<S-l>",
      --   "<cmd>BufExplorer<cr>",
      --   mode = "n",
      --   desc = "Open bufexplorer",
      -- },
    },
  },
}

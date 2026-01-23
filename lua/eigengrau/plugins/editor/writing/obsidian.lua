local prefix = "<leader>o"

return {
  {
    "obsidian-nvim/obsidian.nvim",
    ft = "markdown",
    cmd = "Obsidian",
    event = "BufReadPre " .. vim.fn.expand("~") .. "/Vaults/Littlewing/**.md",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "ibhagwan/fzf-lua",
    },
    keys = {
      { prefix .. "n", "<cmd>Obsidian new<CR>", desc = "New Note" },
      { prefix .. "d", "<cmd>Obsidian today<CR>", desc = "Daily Note" },
      { prefix .. "i", "<cmd>Obsidian pasteimg<CR>", desc = "Paste Image" },
      { prefix .. "s", "<cmd>Obsidian search<CR>", desc = "Search" },
      { prefix .. "t", "<cmd>Obsidian template<CR>", desc = "Template" },
      { prefix .. "q", "<cmd>Obsidian quick_switch<CR>", desc = "Quick Switch" },
      { prefix .. "l", "<cmd>Obsidian links<CR>", desc = "Links" },
      { prefix .. "b", "<cmd>Obsidian backlinks<CR>", desc = "Backlinks" },
      { prefix .. "r", "<cmd>Obsidian rename<CR>", desc = "Rename" },
      
      -- Visual mode keys
      { prefix .. "e", "<cmd>Obsidian extract<CR>", mode = "v", desc = "Extract Note" },
      { prefix .. "l", "<cmd>Obsidian link<CR>", mode = "v", desc = "Link Selection" },
    },
    opts = {
      legacy_commands = false,
      workspaces = {
        {
          name = "Littlewing",
          path = "~/Vaults/Littlewing",
        },
      },

      notes_subdir = "inbox",

      completion = {
        blink = true,
        min_chars = 2,
      },

      create_new = true,

      picker = {
        name = "fzf-lua",
      },

      daily_notes = {
        folder = "logs",
        date_format = "%Y-%m-%d",
        alias_format = "%Y-%m-%d",
        template = "daily-log.md",
      },

      templates = {
        folder = "templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
      },

      attachments = {
        folder = "resources/assets",
      },

      -- UI disabled - render-markdown.nvim handles all visual rendering
      ui = {
        enable = false,
      },
    },
  },
}

return {
  "Hashino/doing.nvim",
  lazy = true,

  keys = {
    { "<leader>da", function() require("doing").add() end,  desc = "[D]oing: [A]dd", },
    { "<leader>dn", function() require("doing").done() end, desc = "[D]oing: Do[n]e", },
    { "<leader>de", function() require("doing").edit() end, desc = "[D]oing: [E]dit", },
  },
  opts = {
    ignored_buffers = { "NvimTree" },

    -- if should append "+n more" to the status when there's tasks remaining
    show_remaining = true,

    -- if should show messages on the status string
    show_messages = true,

    -- window configs of the floating tasks editor
    -- see :h nvim_open_win() for available options
    edit_win_config = {
      width = 50,
      height = 15,
      border = "rounded",
    },

    -- if plugin should manage the winbar
    winbar = { enabled = true, },

    store = {
      -- name of tasks file
      file_name = ".tasks",
      -- if true, tasks file is always in sync with
      -- tasklist, otherwise, tasks get saved to file on
      -- closing neovim or changing cwd
      sync_tasks = false,
    },
  },
}

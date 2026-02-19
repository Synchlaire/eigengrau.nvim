return {
  {
    "jedrzejboczar/possession.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    lazy = true,
    cmd = {"Ssave", "Sload", "Sshow", "Slist", "Smigrate", "Srename", "Sclose", "Sdelete"},
    keys = {
      { "<leader>ss", "<cmd>Slist<CR>", desc = "Sessions list" },
      { "<leader>sS", "<cmd>Ssave<CR>", desc = "Save session" },
      { "<leader>sl", "<cmd>Sload<CR>", desc = "Load session" },
      { "<leader>sd", "<cmd>Sdelete<CR>", desc = "Delete session" },
      { "<leader>sr", "<cmd>Srename<CR>", desc = "Rename session" },
    },
    config = function()
      require("possession").setup {
        session_dir = os.getenv("HOME") .. "/.nvim-sessions",
        silent = false,
        load_silent = true,
        debug = false,
        logfile = false,
        prompt_no_cr = false,
        autosave = {
          current = true,
          tmp = true,
          tmp_name = "temp",
          on_load = true,
          on_quit = true,
        },
        commands = {
          save = "Ssave",
          load = "Sload",
          rename = "Srename",
          close = "Sclose",
          delete = "Sdelete",
          show = "Sshow",
          list = "Slist",
          migrate = "Smigrate",
        },
        hooks = {
          before_save = function(name)
            return {}
          end,
          after_save = function(name, user_data, aborted) end,
          before_load = function(name, user_data)
            return user_data
          end,
          after_load = function(name, user_data) end,
        },
        plugins = {
          close_windows = {
            hooks = { 'before_save', 'before_load' },
            preserve_layout = true,
            match = {
              floating = true,
              buftype = {},
              filetype = {},
              custom = false,
            },
          },
          delete_hidden_buffers = {
            hooks = {
              'before_load',
            },
            force = false,
          },
          symbols_outline = true,
        },
      }
    end,
  },
}
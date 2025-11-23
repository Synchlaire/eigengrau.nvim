return {
  'stevearc/oil.nvim',
  -- lazy = false,
  event = "VeryLazy",
  config = function()
    require("oil").setup({
      constrain_cursor = "editable",
      watch_for_changes = true, --reload oil at each file change
      cleanup_delay_ms = 300,
      columns = {
        "icon",
        -- "permissions",
        -- "size",
        -- "mtime",
      },
      buf_options = {
        buflisted = false,
        bufhidden = "hide",
      },
      win_options = {
        wrap = false,
        signcolumn = "yes:2",
        cursorcolumn = false,
        foldcolumn = "0",
        spell = false,
        list = false,
        conceallevel = 3,
        concealcursor = "nvic",
      },
      default_file_explorer = true,
      restore_win_options = false,
      -- Skip the confirmation popup for simple operations
      skip_confirm_for_simple_edits = true,
      -- Deleted files will be removed with the trash_command (below).
      delete_to_trash = false,
      -- Selecting a new/moved/renamed file or directory will prompt you to save changes first
      prompt_save_on_select_new_entry = true,
      -- Keymaps in oil buffer. Can be any value that `vim.keymap.set` accepts OR a table of keymap
      -- options with a `callback` (e.g. { callback = function() ... end, desc = "", nowait = true })
      -- Additionally, if it is a string that matches "actions.<name>",
      -- it will use the mapping at require("oil.actions").<name>
      -- Set to `false` to remove a keymap
      -- See :help oil-actions for a list of all available actions
      keymaps = {
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["<C-s>"] = "actions.select_vsplit",
        ["<C-h>"] = "actions.select_split",
        ["<C-t>"] = "actions.select_tab",
        ["<a-p>"] = "actions.preview",
        ["<C-o>"] = "actions.open_external",
        ["<C-c>"] = "actions.close",
        ["<C-l>"] = "actions.refresh",
        ["-"] = "actions.parent",
        ["<a-->"] = "actions.open_cwd",
        ["<leader>."] = "actions.cd",
        { scope = "tab", mode = "n" },
        ["g."] = "actions.toggle_hidden",
        ["<leader>--"] = {
          "actions.open_terminal",

          opts = {
            shorten_path = true,
            modify = ":h",
          },
          desc = "Open the command line with the current directory as an argument",
        },
        ["<leader><leader>"] = {
          function()
            require("telescope.builtin").find_files({
              cwd = require("oil").get_current_dir()
            })
          end,
          mode = "n",
          nowait = true,
          desc = "Find files in the current directory"
        }
      },

      -- Set to false to disable all of the above keymaps
      use_default_keymaps = false,
      view_options = {
        natural_order = "fast", -- fast, true or false
        show_hidden = false,
        -- This function defines what is considered a "hidden" file
        is_hidden_file = function(name, bufnr)
          return vim.startswith(name, ".")
        end,
        -- This function defines what will never be shown, even when `show_hidden` is set
        is_always_hidden = function(name, bufnr)
          return false
        end,
      },

      -- Configuration for the floating window in oil.open_float
      float = {
        -- Padding around the floating window
        padding = 2,
        max_width = 0,
        max_height = 0,
        border = "rounded",
        win_options = {
          winblend = 10,
        },
      },
      -- Configuration for the actions floating preview window
      preview_win = {
        update_on_cursor_moved = true,
        preview_method = "fast_scratch", -- load, fast, fast_scratch
        max_width = 0.9,
        min_width = { 40, 0.4 },
        width = nil,
        max_height = 0.9,
        min_height = { 5, 0.1 },
        height = nil,
        border = "rounded",
        win_options = {
          winblend = 0,
        },
      },
      -- Configuration for the floating progress window
      progress = {
        max_width = 0.9,
        min_width = { 40, 0.4 },
        width = nil,
        max_height = { 10, 0.9 },
        min_height = { 5, 0.1 },
        height = nil,
        border = "rounded",
        minimized_border = "none",
        win_options = {
          winblend = 0,
        },
        dependencies = { "nvim-tree/nvim-web-devicons" },

      },
      vim.keymap.set("n", "-", require("oil").open, { desc = "Open parent directory" })
    })
  end,
}

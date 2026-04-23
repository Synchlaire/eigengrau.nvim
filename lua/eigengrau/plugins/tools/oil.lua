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
            require("snacks").picker.files({
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
        border = "single",
        win_options = {
          winblend = 5,
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
        border = "single",
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
        border = "single",
        minimized_border = "none",
        win_options = {
          winblend = 0,
        },
      },
    })

    vim.keymap.set("n", "-", require("oil").open, { desc = "Open parent directory" })

    -- Image preview on cursor-hover in oil buffers (uses Snacks.image).
    -- Replaces focal.nvim + image.nvim with the single Snacks backend, so we
    -- get Ghostty's native graphics protocol with no extra plugins.
    local hover ---@type { win: table, img: table, src: string } | nil

    local function close_hover()
      if hover then
        pcall(function() hover.img:close() end)
        pcall(function() hover.win:close() end)
        hover = nil
      end
    end

    local function show_hover()
      local ok_snacks = type(_G.Snacks) == "table"
          and type(Snacks.image) == "table"
      if not ok_snacks then return end
      if not Snacks.image.supports_terminal() then return end

      local ok_oil, oil = pcall(require, "oil")
      if not ok_oil then return end
      local entry = oil.get_cursor_entry()
      local dir = oil.get_current_dir()
      if not (entry and dir) or entry.type ~= "file" then
        return close_hover()
      end

      local path = dir .. entry.name
      if not Snacks.image.supports_file(path) then
        return close_hover()
      end

      -- Same image already shown — nothing to do.
      if hover and hover.src == path then return end
      close_hover()

      local win = Snacks.win(Snacks.win.resolve("snacks_image", {
        show = false,
        enter = false,
        relative = "cursor",
        row = 1,
        col = 4,
        border = "rounded",
        backdrop = false,
        focusable = false,
        wo = {
          winblend = Snacks.image.terminal.env().placeholders and 0 or nil,
        },
      }))
      win:open_buf()
      local img = Snacks.image.placement.new(win.buf, path, {
        auto_resize = true,
        max_width = 60,
        max_height = 30,
        on_update_pre = function(placement)
          local loc = placement:state().loc
          win.opts.width = loc.width
          win.opts.height = loc.height
          if not win:valid() then win:show() end
        end,
        on_update = function() if win:valid() then win:update() end end,
      })
      hover = { win = win, img = img, src = path }
    end

    local group = vim.api.nvim_create_augroup("EigengrauOilImagePreview", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      pattern = "oil",
      callback = function(ev)
        vim.api.nvim_create_autocmd({ "CursorMoved", "BufLeave", "WinLeave" }, {
          group = group,
          buffer = ev.buf,
          callback = function(e)
            if e.event == "CursorMoved" then
              vim.schedule(show_hover)
            else
              close_hover()
            end
          end,
        })
      end,
    })
  end,
}

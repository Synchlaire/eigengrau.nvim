-- Optional UI enhancements
return {
  -- Transparency
  {
    "xiyaowong/transparent.nvim",
    event = "VeryLazy",
    config = function()
      require("transparent").setup({
        groups = {
          "StatusLine",
          "StatusLineNC",
          "FocusBg",
          "NormalFloat",
          "Pmenu",
          "SignColumn",
          "FoldColumn",
          "TabLineFill",
          "TabLine",
          "WinBar",
        },
        exclude_groups = {},
      })
    end,
  },

  -- Color highlighting
  {
    "brenoprata10/nvim-highlight-colors",
    cmd = "HighlightColors",
    config = function()
      require("nvim-highlight-colors").setup({
        render = "background",
        virtual_symbol = "■",
        virtual_symbol_prefix = "",
        virtual_symbol_suffix = " ",
        virtual_symbol_position = "inline",
        enable_hex = true,
        enable_short_hex = true,
        enable_rgb = true,
        enable_hsl = true,
        enable_var_usage = true,
        enable_named_colors = true,
        enable_tailwind = true,
        custom_colors = {
          { label = "%-%-theme%-primary%-color",   color = "#0f1219" },
          { label = "%-%-theme%-secondary%-color", color = "#5a5d64" },
        },
        exclude_filetypes = {},
        exclude_buftypes = {},
      })
    end,
  },

  -- Window management
  {
    "anuvyklack/windows.nvim",
    dependencies = {
      "anuvyklack/middleclass",
      "anuvyklack/animation.nvim",
    },
    cmd = { "WindowsMaximize", "WindowsMaximizeVertically", "WindowsMaximizeHorizontally", "WindowsEqualize" },
    config = function()
      vim.o.winwidth = 10      -- Allow true fullscreen (default 20 prevents it)
      vim.o.winminwidth = 5    -- Minimum width for side windows
      vim.o.winheight = 1      -- Allow vertical maximize
      vim.o.winminheight = 1   -- Minimum height for splits

      require("windows").setup({
        equalalways = false,
        autowidth = {
          enable = false,
          filetype = {},
        },
        ignore = {
          buftype = { "quickfix", "oil" },
          filetype = { "NvimTree", "neo-tree", "undotree", "gundo" },
        },
        animation = {
          enable = true,
          duration = 150,  -- Snappier (was 200ms)
          fps = 60,
          easing = "in_out_sine",
        },
      })
    end,
  },

  -- Window rearrangement
  {
    "sindrets/winshift.nvim",
    cmd = "WinShift",
    config = function()
      require("winshift").setup({
        highlight_moving_win = true,
        focused_hl_group = "Visual",
        moving_win_options = {
          wrap = true,
          cursorline = true,
          cursorcolumn = true,
          colorcolumn = "",
        },
        keymaps = {
          disable_defaults = false,
          win_move_mode = {
            ["h"] = "left",
            ["j"] = "down",
            ["k"] = "up",
            ["l"] = "right",
            ["H"] = "far_left",
            ["J"] = "far_down",
            ["K"] = "far_up",
            ["L"] = "far_right",
          },
        },
        window_picker = function()
          return require("winshift.lib").pick_window({
            picker_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
            filter_rules = {
              cur_win = true,
              floats = true,
              filetype = {},
              buftype = {},
              bufname = {},
            },
            filter_func = nil,
          })
        end,
      })
    end,
  },
}

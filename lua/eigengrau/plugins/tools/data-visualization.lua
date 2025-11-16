return{
  -- json, yaml, toml
  {
    "Owen-Dechow/videre.nvim",
    lazy = true,
    cmd = "Videre",
    dependencies = {
      "Owen-Dechow/graph_view_yaml_parser", -- Optional: add YAML support
      "Owen-Dechow/graph_view_toml_parser", -- Optional: add TOML support
      "a-usr/xml2lua.nvim", -- Optional | Experimental: add XML support
    },
    opts = {
      simple_statusline = true, -- If you are just starting out with Videre,
      --   setting this to `false` will give you
      --   descriptions of available keymaps.
      -- set the window editor type
      editor_type = "floating", -- split, floating

      -- configure the floating window style
      floating_editor_style = {
        margin = 2,
        border = "double",
        zindex = 10
      },

      -- Number of lines before collapsing
      max_lines = 5,

      -- Set the unit style to round
      round_units = true,

      -- Set the connection style to round
      round_connections = true,

      -- Disable line wrapping for the graph buffer
      disable_line_wrap = true,

      -- Set side scroll off for graph buffer
      side_scrolloff = 20,

      -- Change the string between the keymap and
      --   description of callback within the statusline
      -- FOR FONTS WITH LIGATURES TRY USING "꞊" INSTEAD OF "=".
      -- Other great options include "->", ": ", "=>", & " ".
      keymap_desc_deliminator = "=",

      -- Character used to represent empty space
      space_char = "·",
      -- Show breadcrumbs to show where you are in
      --   a Videre graph.
      breadcrumbs = true,

      -- Set the priority of keymaps for the quick
      --   action keymap.
      keymap_priorities = {
        expand = 5,
        link_forward = 4,
        link_backward = 3,
        link_down = 1,
        link_up = 1,
        collapse = 2,
        set_as_root = 1,
      },

      -- Set the keys actions will be mapped to
      keymaps = {
        -- Expanding collapsed areas
        expand = "E",

        -- Collapse expanded areas
        collapse = "E",

        -- Jump to linked unit
        link_forward = "L",

        -- Jump back to unit parent
        link_backward = "H",

        -- Jump down a unit
        link_down = "J",

        -- Jump up a unit
        link_up = "K",

        -- Set current unit as root
        set_as_root = "R",

        -- Aliased to first priority available keymap
        quick_action = "<CR>",

        -- Close the window
        close_window = "q",

        -- Open the help menu
        help = "g?",

        -- Change the key of the current field
        change_key = "C",

        -- Change the value of the current field
        change_value = "V",

        -- Delete the current field
        delete_field = "D",

        -- Add a field to the unit
        add_field = "A",
      }
    }
  },

  -- csv, tsv
{
  "hat0uma/csvview.nvim",
  lazy = true,
  ft = { "csv", "tsv" },
  opts = {

    parser = {
      async_chunksize = 50,
      delimiter = {
        ft = {
          csv = ",",
          tsv = "\t",
        },
        fallbacks = {
          ",",
          "\t",
          ";",
          "|",
          ":",
          " ",
        },
      },
      quote_char = '"',
      comments = {
        "#",
        "--",
        "//",
      },

      max_lookahead = 50,
    },
    view = {
      min_column_width = 5,
      spacing = 2,
      display_mode = "border",
      header_lnum = true,
      sticky_header = {
        enabled = true,
        separator = "─",
      },
    },
  },
  cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
}
}

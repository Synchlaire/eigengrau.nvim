return {
  "RedsXDD/neopywal.nvim",
  name = "neopywal",
  lazy = false,
--  cmd = "Huez",
--  priority = 1001,
  config = function()
    require("neopywal").setup({
      use_wallust = true,
      colorscheme_file = "/home/claroscuro/.cache/wallust/neopywal.vim",
      -- This option allows to use a custom built-in theme palettes like "catppuccin-mocha" or "tokyonight".
      -- To get the list of available themes take a look at `:h neopywal-alternative-palettes` or at
      -- `https://github.com/RedsXDD/neopywal.nvim#Alternative-Palettes`.
      -- Take note that this option takes precedence over `use_wallust` and `colorscheme_file`.
      -- use_palette = "",

      -- Sets the background color of certain highlight groups to be transparent.
      -- Use this when your terminal opacity is < 1.
      transparent_background = false,

      -- With this option you can overwrite all the base colors the colorscheme uses.
      custom_colors = {},

      -- With this option you can overwrite any highlight groups set by the colorscheme.
      -- For more information scroll down (https://github.com/RedsXDD/neopywal.nvim#Customizing-Highlights)
      custom_highlights = {},

      -- Dims the background when another window is focused.
      dim_inactive = false,

      -- Apply colorscheme for Neovim's terminal (e.g. `g:terminal_color_0`).
      terminal_colors = true,

      -- Shows the '~' characters after the end of buffers.
      show_end_of_buffer = false,

      -- Shows the '|' split separator characters.
      -- It's worth noting that this option works better in conjunction with `dim_inactive`.
      show_split_lines = true,

      no_italic = false, -- Force no italic.
      no_bold = false, -- Force no bold.
      no_underline = false, -- Force no underline.
      no_undercurl = false, -- Force no undercurl.
      no_strikethrough = false, -- Force no strikethrough.

      -- Handles the styling of certain highlight groups (see `:h highlight-args`).
      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
        loops = {},
        functions = { "bold" },
        keywords = { "bold" },
        includes = { "italic" },
        strings = {},
        variables = { "italic" },
        numbers = {},
        booleans = {},
        types = { "italic" },
        operators = {},
      },

      -- Setting this to false disables all default file format highlights.
      -- Useful if you want to enable specific file format options.
      -- NOTE: if the treesitter plugin integration is enabled, this option
      -- will be automatically set to false unless the user manually sets it back on
      -- using the setup() function.
      default_fileformats = true,

      -- Setting this to false disables all default plugin highlights.
      -- Useful if you want to enable specific plugin options.
      default_plugins = true,

      fileformats = {
        -- For more fileformats options please scroll down (https://github.com/RedsXDD/neopywal.nvim#Fileformats)
      },

      -- For more plugin options please scroll down (https://github.com/RedsXDD/neopywal.nvim#Plugins)
      plugins = {
        -- easy setup
        alpha = true,
        git_gutter = true,
        lazy = true,
        lazygit = true,
        noice = true,
        notify = true,
        nvim_cmp = true,
        treesitter = true,
        which_key = true,

        -- these ones are proper modules

        telescope = { enabled = true, style = "nvchad" },
        colorful_winsep = {
          enabled = true,
          -- One of Neopywal's colors exported by "get_colors()" (e.g.: `color8`)
          -- or a hexadecimal color (e.g.: "#ff0000"), default: `color4`
          color = "4",
        },
        indent_blankline = {
          enabled = true,
          -- One of Neopywal's colors exported by "get_colors()" (e.g.: `color8`)
          -- or a hexadecimal color (e.g.: "#ff0000"), default: `comment`
          scope_color = "",
          colored_indent_levels = false,
        },
        flash = {
          enabled = true,
          style = { "bold", "italic" },
        },
      },
    })
  end
}

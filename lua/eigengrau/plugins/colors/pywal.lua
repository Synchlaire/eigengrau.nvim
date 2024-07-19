--return {
--  { 'uZer/pywal16.nvim' ,
--    --    name = 'pywal16',
--    config = function()
--    end
--  },
--}

return {
  "RedsXDD/neopywal.nvim",
  name = "neopywal",
  lazy = true,
  cmd = "Huez",
--  priority = 1001,
  config = function()
    require("neopywal").setup({
      use_wallust = true,
      colorscheme_file = "/home/claroscuro/.cache/wallust/neopywal.vim",

      -- This option allows to use a custom built-in theme palettes like "catppuccin-mocha" or "tokyonight".
      -- To get the list of available themes take a look at `:h neopywal-alternative-palettes` or at
      -- `https://github.com/RedsXDD/neopywal.nvim#Alternative-Palettes`.
      -- Take note that this option takes precedence over `use_wallust` and `colorscheme_file`.
      --    use_palette = "",

      -- Sets the background color of certain highlight groups to be transparent.
      -- Use this when your terminal opacity is < 1.
      transparent_background = false,

      -- With this option you can overwrite all the base colors the colorscheme uses.
      custom_colors = {},

      -- With this option you can overwrite any highlight groups set by the colorscheme.
      -- For more information scroll down (https://github.com/RedsXDD/neopywal.nvim#Customizing-Highlights)
      custom_highlights = {},

      -- Dims the background when another window is focused.
      dim_inactive = true,

      -- Apply colorscheme for Neovim's terminal (e.g. `g:terminal_color_0`).
      terminal_colors = true,

      -- Shows the '~' characters after the end of buffers.
      show_end_of_buffer = false,

      -- Shows the '|' split separator characters.
      -- It's worth noting that this options works better in conjunction with `dim_inactive`.
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
	functions = {},
	keywords = {},
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

      -- For more fileformats options please scroll down (https://github.com/RedsXDD/neopywal.nvim#Fileformats)
      fileformats = {
	c_cpp = true,
	c_sharp = true,
      },

      -- For more plugin options please scroll down (https://github.com/RedsXDD/neopywal.nvim#Plugins)
      plugins = {
	alpha = true,
	dashboard = false,
	git_gutter = true,
	indent_blankline = true,
	lazy = true,
	lazygit = true,
	noice = true,
	notify = true,
	nvim_cmp = true,
	treesitter = true,
	telescope = { enabled = true, style = "nvchad" },
	which_key = true,
	mini = {
	  hipatterns = false,
	  indentscope = false,
	  pick = false,
	  starter = false,
	},
      }
    })
  end
}

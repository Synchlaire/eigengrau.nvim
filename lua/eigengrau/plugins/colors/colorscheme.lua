return {

  {"aliqyan-21/darkvoid.nvim",
    lazy = true,
    config = function()
      require('darkvoid').setup ({
	transparent = true, -- set true for transparent
	glow = true, -- set true for glow effect
	show_end_of_buffer = false, -- set false for not showing end of buffer

	colors = {
	  fg = "#c0c0c0",
	  bg = "#1c1c1c",
	  cursor = "#bdfe58",
	  line_nr = "#404040",
	  visual = "#303030",
	  comment = "#585858",
	  string = "#d1d1d1",
	  func = "#e1e1e1",
	  kw = "#f1f1f1",
	  identifier = "#b1b1b1",
	  type = "#a1a1a1",
	  search_highlight = "#1bfd9c",
	  operator = "#1bfd9c",
	  bracket = "#e6e6e6",
	  preprocessor = "#4b8902",
	  bool = "#66b2b2",
	  constant = "#b2d8d8",

	  -- gitsigns colors
	  added = "#baffc9",
	  changed = "#ffffba",
	  removed = "#ffb3ba",

	  -- Pmenu colors
	  pmenu_bg = "#1c1c1c",
	  pmenu_sel_bg = "#1bfd9c",
	  pmenu_fg = "#c0c0c0",

	  -- EndOfBuffer color
	  eob = "#3c3c3c",

	  -- Telescope specific colors
	  border = "#585858",
	  title = "#bdfe58",

	  -- bufferline specific colors
	  -- change this to change the colors of current or selected tab
	  bufferline_selection = "#bdfe58"

	  -- LSP diagnostics colors
--	  error = "#DEA6A0",
--	  warning = "#D0B8A8",
--	  hint = "#BEDC74",
--	  info = "#7FA1C3",
	},
      })
    end
  },

  --- base16
--  "RRethy/base16-nvim",
--  lazy = false,
--  config = function()
--    require("base16-colorscheme").setup({
--      telescope = true,
--      indentblankline= true,
--      notify = true,
--      ts_rainbow = true,
--      cmp = true,
--      illuminate = true,
--      dapui = true,
--    })
--  end,
--
  {
    --- nightfly
    "bluz71/vim-nightfly-colors",
    lazy = false,
    config = function()
      local g = vim.g
      g.nightflyCursorColor = true
      g.nightflyItalics = true
      g.nightflyNormalFloat = false
      g.nightflyTerminalColors = true
      g.nightflyTransparent = false
      g.nightflyUndercurls = true
      g.nightflyUnderlineMatchParen = false
      g.nightflyWinSeparator = 0
      g.nightflyVirtualTextColor = true
    end,
  },

  {
    "nyoom-engineering/oxocarbon.nvim",
    lazy = true,
  },

  {
    --- plain
    "andreypopp/vim-colors-plain",
    lazy = true,
    config = function()
      --    vim.cmd[[colorscheme plain]]
    end,
  },

--  {
--    "black-atom-industries/black-atom.nvim",
--    lazy = false,
--    dependencies = {
--      "black-atom-industries/black-atom-vault", --    pin = true, lazy = true,
--    },
--    opts = {
--      debug = false,
--      styles = {
--	dark_sidebars = true,
--	transparency = "none",
--	cmp_kind_color_mode = "bg",
--	diagnostics = {
--	  background = true,
--	},
--      },
--    }
--  },
--

  {
    {
      "craftzdog/solarized-osaka.nvim",
      lazy = false,
      opts = function()
	return {
	  transparent = true,
	}
      end,
    },

  },
  "RedsXDD/neopywal.nvim",
  name = "neopywal",
  --  cmd = "Huez",
  --  priority = 1001,
  init = function()
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
      transparent_background = true,

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

      no_italic = false,     -- Force no italic.
      no_bold = false,       -- Force no bold.
      no_underline = false,  -- Force no underline.
      no_undercurl = false,  -- Force no undercurl.
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
  end,
}

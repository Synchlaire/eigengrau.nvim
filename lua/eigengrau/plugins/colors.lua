return {

--- plain
    'andreypopp/vim-colors-plain',
    priority = 1000,
    config = function()
        vim.cmd([[colorscheme plain]])
    end,

    --- monet
    'fynnfluegge/monet.nvim',
    lazy = true,
    config = function()
        require("monet").setup {
            transparent_background = false,
            semantic_tokens = true,
            dark_mode = true,
            highlight_overrides= {
                --        Normal = { fg = #c2f5bf },
                --        TelescopeMatching = { fg = #5cd5db },
            },
            color_overrides = {},
            styles = {
                strings = { "italic", "bold" },
            },
        }
    end,
--- nightfly

  'bluz71/vim-nightfly-colors',
    name = 'nightfly',
    lazy = true,
  config = function()
      local g = vim.g
      g.nightflyCursorColor = true
      g.nightflyItalics = true
      g.nightflyNormalFloat = true
      g.nightflyTerminalColors = true
      g.nightflyTransparent = false
      g.nightflyUndercurls = true
      g.nightflyUnderlineMatchParen = false
      g.nightflyWinSeparator = 2
      g.nightflyVirtualTextColor = true
  end,

--- poimandres
    'olivercederborg/poimandres.nvim',
    lazy = true,
    config = function()
        require("poimandres").setup {
            bold_vert_split = true,        -- use bold vertical separators
            dim_nc_background = true,      -- dim 'non-current' window backgrounds
            disable_background = false,     -- disable background
            disable_float_background = true, -- disable background for floats
            disable_italics = false,       -- disable italics
        }
    end,

--- solar-osaka
 'craftzdog/solarized-osaka.nvim',
  lazy = true,
 config = function()
require("solarized-osaka").setup({
    -- your configuration comes here
    -- or leave it empty to use the default settings
    --  transparent = true, -- Enable this to disable setting the background color
    terminal_colors = true, -- Configure the colors used when opening a `:terminal` in [Neovim](https://github.com/neovim/neovim)
    styles = {
        -- Style to be applied to different syntax groups
        -- Value is any valid attr-list value for `:help nvim_set_hl`
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
        -- Background styles. Can be "dark", "transparent" or "normal"
        sidebars = "transparent", -- style for sidebars, see below
        floats = "transparent", -- style for floating windows
    },
    sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
    day_brightness = 1.0, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
    hide_inactive_statusline = true, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
    dim_inactive = true, -- dims inactive windows
    lualine_bold = true, -- When `true`, section headers in the lualine theme will be bold

    --- You can override specific color groups to use other groups or a hex color
    --- function will be called with a ColorScheme table
    ---@param colors ColorScheme
    on_colors = function(colors) end,

    --- You can override specific highlights to use other groups or a hex color
    --- function will be called with a Highlights and ColorScheme table
    ---@param highlights Highlights
    ---@param colors ColorScheme
    on_highlights = function(highlights, colors) end,
})
end,

}
--  'haishanh/night-owl.vim', event = "Colorscheme",
--  'lamartire/hg.vim', event = "Colorscheme",
--  'lunarvim/templeos.nvim', event = "VeryLazy", -- chad mode
--  'nyoom-engineering/oxocarbon.nvim', event = "Colorscheme",
--  'olivercederborg/poimandres.nvim', event = "Colorscheme",
--  'relastle/bluewery.vim', event = "Colorscheme",
--  'sts10/vim-pink-moon', event = "Colorscheme",
--  'talha-akram/noctis.nvim', event = "Colorscheme",
--  'uZer/pywal16.nvim', branch = 'newcolors', name = 'pywal16',

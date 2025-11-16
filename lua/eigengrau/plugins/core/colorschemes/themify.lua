---@diagnostic disable: unused-local

return {
  'lmantw/themify.nvim',
  dependencies = "rktjmp/lush.nvim",
  lazy = false,
  priority = 999,
  config = function()
    require('themify').setup({

      -- my list of colorschemes.
      -- uncomment the ones you'd like to install

      -- Plain (local colorscheme - auto-switching)
      -- Variants: plain (auto), plain-dark (forced dark), plain-light (forced light)
      {
        "plain",
        before = function()
          -- Customize palettes before loading (optional)
          -- Access via: require("colors.plain").palettes.dark.bg = "#000000"
          local plain = require("colors.plain")
          -- Example customizations (uncomment to use):
          -- plain.palettes.dark.bg = "#000000"         -- Pure black bg
          -- plain.palettes.dark.accent = "#ff87af"     -- Pink accent
          -- plain.palettes.light.bg = "#ffffff"        -- Pure white bg
        end
      },
      {
        "plain-dark",
        before = function()
          local plain = require("colors.plain")
          -- Customize dark palette here
        end
      },
      {
        "plain-light",
        before = function()
          local plain = require("colors.plain")
          -- Customize light palette here
        end
      },
      -- Neopywal
      -- { "neopywal" },
      { "bettervim/yugen.nvim" },
      -- monoglow
      -- { "wnkz/monoglow.nvim" },

      -- techbase
      { "mcauley-penney/techbase.nvim" },
      { "mcauley-penney/phobos-anomaly.nvim" },

      -- black-atom
      -- { "black-atom-mnml-mikado-dark" },
      -- { "black-atom-mnml-47-dark" },
      -- { "black-atom-mnml-47-light" },
      -- { "black-atom-mnml-mono-dark" },
      -- { "black-atom-mnml-mono-light" },
      -- { "black-atom-stations-engineering" },
      -- { "black-atom-stations-medical" },
      -- { "black-atom-stations-operations" },

      -- Lackluster
      {
        "slugbyte/lackluster.nvim",
        before = function(theme)
          Tweak_background = {
            normal = 'default',    -- main background
            -- normal = 'none',       -- transparent
            telescope = 'default', -- telescope
            menu = 'default',      -- nvim_cmp, wildmenu (bad idea to transparent)
            popup = 'default',     -- lazy, mason, whichkey (bad idea to transparent)
          }
        end
      },


      -- kanso
      {
        "webhooked/kanso.nvim",
        before = function(theme)
          require('kanso').setup({
            bold = true,      -- enable bold fonts
            italics = true,   -- enable italics
            compile = false,  -- enable compiling the colorscheme
            undercurl = true, -- enable undercurls
            commentStyle = { italic = true },
            functionStyle = { bold = true },
            keywordStyle = { italic = true },
            statementStyle = {},
            typeStyle = {},
            transparent = false,   -- do not set background color
            dimInactive = false,   -- dim inactive window `:h hl-NormalNC`
            terminalColors = true, -- define vim.g.terminal_color_{0,17}
            colors = {             -- add/modify theme and palette colors
              palette = {},
              theme = { zen = {}, pearl = {}, ink = {}, all = {} },
            },
            overrides = function(colors) -- add/modify highlights
              return {}
            end,
            theme = "zen",    -- Load "zen" theme
            background = {    -- map the value of 'background' option to a theme
              dark = "zen",   -- try "ink" !
              light = "pearl" -- try "mist" !
            },
          })
        end
      },

      -- nightfly
      {
        "bluz71/vim-nightfly-colors",
        before = function(theme)
          local g = vim.g
          g.nightflyCursorColor = true
          g.nightflyItalics = true
          g.nightflyNormalFloat = true
          g.nightflyTerminalColors = true
          g.nightflyTransparent = false
          g.nightflyUndercurls = true
          g.nightflyUnderlineMatchParen = true
          g.nightflyWinSeparator = 0
          g.nightflyVirtualTextColor = true
        end,

      },



      -- Solarized-osaka
      {
        "craftzdog/solarized-osaka.nvim",
        before = function(theme)
          require("solarized-osaka").setup({
            -- your configuration comes here
            -- or leave it empty to use the default settings
            transparent = false,    -- Enable this to disable setting the background color
            terminal_colors = true, -- Configure the colors used when opening a `:terminal` in [Neovim](https://github.com/neovim/neovim)
            styles = {
              -- Style to be applied to different syntax groups
              -- Value is any valid attr-list value for `:help nvim_set_hl`
              comments = { italic = true },
              keywords = { italic = true },
              functions = { bold = true },
              variables = { bold = true },
              -- Background styles. Can be "dark", "transparent" or "normal"
              sidebars = "dark",                     -- style for sidebars, see below
              floats = "dark",                       -- style for floating windows
            },
            sidebars = { "qf", "help", "terminal" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
            day_brightness = 0.7,                    -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
            hide_inactive_statusline = true,         -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
            dim_inactive = false,                    -- dims inactive windows
            lualine_bold = false,                    -- When `true`, section headers in the lualine theme will be bold

            --- You can override specific color groups to use other groups or a hex color
            --- function will be called with a ColorScheme table
            on_colors = function(colors) end,

            --- You can override specific highlights to use other groups or a hex color
            --- function will be called with a Highlights and ColorScheme table
            on_highlights = function(highlights, colors) end,
          })
        end
      },

      -- zenbones (only zenwritten and neobones)
      {
        "zenbones-theme/zenbones.nvim",
        colorschemes = {
          { "zenwritten" },
          { "neobones" },
        },
      },


      -- vague
      {
        "vague2k/vague.nvim",
        before = function(theme)
          require("vague").setup({
            transparent = false, -- don't set background
            -- disable bold/italic globally in `style`
            bold = true,
            italic = true,
            style = {
              -- "none" is the same thing as default. But "italic" and "bold" are also valid options
              boolean = "bold",
              number = "none",
              float = "none",
              error = "bold",
              comments = "italic",
              conditionals = "none",
              functions = "none",
              headings = "bold",
              operators = "none",
              strings = "italic",
              variables = "none",

              -- keywords
              keywords = "none",
              keyword_return = "italic",
              keywords_loop = "none",
              keywords_label = "none",
              keywords_exception = "none",

              -- builtin
              builtin_constants = "bold",
              builtin_functions = "none",
              builtin_types = "bold",
              builtin_variables = "none",
            },
            -- plugin styles where applicable
            -- make an issue/pr if you'd like to see more styling options!
            plugins = {
              cmp = {
                match = "bold",
                match_fuzzy = "bold",
              },
              dashboard = {
                footer = "italic",
              },
              lsp = {
                diagnostic_error = "bold",
                diagnostic_hint = "none",
                diagnostic_info = "italic",
                diagnostic_ok = "none",
                diagnostic_warn = "bold",
              },
              neotest = {
                focused = "bold",
                adapter_name = "bold",
              },
              telescope = {
                match = "bold",
              },
            },
            -- Override colors
            colors = {
              -- bg = "#141415",
              bg = "#000000",
              inactiveBg = "#6e94b2",
              fg = "#cdcdcd",
              floatBorder = "none",
              line = "none",
              comment = "#606079",
              builtin = "#b4d4cf",
              func = "#c48282",
              string = "#e8b589",
              number = "#e0a363",
              property = "#c3c3d5",
              constant = "#aeaed1",
              parameter = "#bb9dbd",
              visual = "#333738",
              error = "#d8647e",
              warning = "#f3be7c",
              hint = "#7e98e8",
              operator = "#90a0b5",
              keyword = "#6e94b2",
              type = "#9bb4bc",
              search = "#405065",
              plus = "#7fa563",
              delta = "#f3be7c",
            },
          })
        end
      },
    })
  end,

  async = true, -- helps with loading times
  activity = false,

}

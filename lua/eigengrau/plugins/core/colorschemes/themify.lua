---@diagnostic disable: unused-local

return {
  "lmantw/themify.nvim",
  dependencies = {
    "rktjmp/lush.nvim",
    { dir = vim.fn.expand("~/spaces/neovim/wing.nvim"), name = "wing.nvim" },
  },
  lazy = false,
  priority = 999,
  config = function()
    require("themify").setup({

      {
        "Synchlaire/compline.nvim",
        whitelist = { "compline", "compline-dark", "compline-lauds" },
      },

      {
        "Synchlaire/wing.nvim",
        whitelist = { "wing", "darkwing", "lightwing" },
        before = function()
          require("wing").setup({
            transparent = false,
            italic_comments = true,
            bold_keywords = true,
            bold_functions = true,
            terminal_colors = true,
          })
        end,
      },

      -- {
      --   "kungfusheep/mfd.nvim",
      -- },

      {
        "serhez/teide.nvim",
      },

      { "sontungexpt/witch" },

      -- black-atom
      {
        "black-atom-industries/nvim",
        name = "black-atom",
        whitelist = {
          "black-atom-mnml-mikado-dark",
          "black-atom-mnml-47-dark",
          "black-atom-mnml-47-light",
          "black-atom-mnml-mono-dark",
          "black-atom-mnml-mono-light",
          "black-atom-mnml-jpn-tsuki-yoru",
          "black-atom-stations-engineering",
          "black-atom-stations-medical",
          "black-atom-stations-operations",
        },
        before = function(theme)
          require("black-atom").setup({
            transparent = false,
            contrast = true,
          })
        end,
      },

      -- Lackluster
      {
        "slugbyte/lackluster.nvim",
        whitelist = { "lackluster", "lackluster-night" },
        before = function(theme)
          Tweak_background = {
            normal = "default",
            telescope = "default",
            menu = "default",
            popup = "default",
          }
        end,
      },

      -- kanso
      {
        "webhooked/kanso.nvim",
        whitelist = { "kanso-zen", "kanso-pearl" },
        before = function(theme)
          require("kanso").setup({
            bold = true,
            italics = true,
            compile = false,
            undercurl = true,
            commentStyle = { italic = true },
            functionStyle = { bold = true },
            keywordStyle = { italic = true },
            statementStyle = {},
            typeStyle = {},
            transparent = false,
            dimInactive = false,
            terminalColors = true,
            colors = {
              palette = {},
              theme = { zen = {}, pearl = {}, ink = {}, all = {} },
            },
            overrides = function(colors)
              return {}
            end,
            theme = "zen",
            background = {
              dark = "zen",
              light = "pearl",
            },
          })
        end,
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
        whitelist = { "solarized-osaka" },
        before = function(theme)
          require("solarized-osaka").setup({
            transparent = false,
            terminal_colors = true,
            styles = {
              comments = { italic = true },
              keywords = { italic = true },
              functions = { bold = true },
              variables = { bold = true },
              sidebars = "dark",
              floats = "dark",
            },
            sidebars = { "qf", "help", "terminal" },
            day_brightness = 0.7,
            hide_inactive_statusline = true,
            dim_inactive = false,
            lualine_bold = false,
            on_colors = function(colors) end,
            on_highlights = function(highlights, colors) end,
          })
        end,
      },

      -- zenbones
      {
        "zenbones-theme/zenbones.nvim",
        whitelist = { "zenwritten", "neobones" },
      },

      -- vague
      {
        "vague2k/vague.nvim",
        before = function(theme)
          require("vague").setup({
            transparent = false,
            bold = true,
            italic = true,
            style = {
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
              keywords = "none",
              keyword_return = "italic",
              keywords_loop = "none",
              keywords_label = "none",
              keywords_exception = "none",
              builtin_constants = "bold",
              builtin_functions = "none",
              builtin_types = "bold",
              builtin_variables = "none",
            },
            plugins = {
              cmp = { match = "bold", match_fuzzy = "bold" },
              dashboard = { footer = "italic" },
              lsp = {
                diagnostic_error = "bold",
                diagnostic_hint = "none",
                diagnostic_info = "italic",
                diagnostic_ok = "none",
                diagnostic_warn = "bold",
              },
              neotest = { focused = "bold", adapter_name = "bold" },
              telescope = { match = "bold" },
            },
            colors = {
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
        end,
      },
    })
  end,

  async = true,
  activity = false,
}

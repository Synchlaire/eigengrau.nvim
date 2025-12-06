return {
  { -- compatibility with cmp-plugins:
    "Saghen/blink.compat",
    lazy = true,
    opts = {},
  },

  { -- blink
    "saghen/blink.cmp",
    version = "*",
    lazy = true,
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "L3MON4D3/LuaSnip" },
      { "nvim-lua/plenary.nvim" },
      { "folke/snacks.nvim" },
      { "MahanRahmati/blink-nerdfont.nvim" },
      { "mikavilpas/blink-ripgrep.nvim" },
      { "rafamadriz/friendly-snippets" },

      -- { 'R-nvim/cmp-r' },
    },
    opts = {
      keymap = {
        preset = "enter",
        --        ['<A-CR>'] = { 'select_and_accept' },
        ["<A-Tab>"] = { "select_next", "fallback" },
        ["<A-j>"] = { "select_next", "fallback" },
        ["<A-k>"] = { "select_prev", "fallback" },
        ["<A-p>"] = { "select_prev", "fallback" },
        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
        ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
        ["<C-g>"] = {
          function()
            require("blink-cmp").show({ providers = { "ripgrep" } })
          end,
        },
        ["<C-s>"] = { -- show a specified provider
          function(cmp)
            cmp.show({
              providers = {
                "snippets",
              },
            })
          end,
        },
      },
      cmdline = { enabled = true },
      appearance = {
        nerd_font_variant = "mono",
        kind_icons = {
          Text = "",
          Method = "",
          Function = "",
          Constructor = "",
          Field = "",
          Variable = "",
          Class = "",
          Interface = "",
          Module = "",
          Property = "",
          Unit = "",
          Value = "",
          Enum = "",
          Keyword = "",
          Snippet = "",
          Color = "",
          File = "",
          Reference = "",
          Folder = "",
          EnumMember = "",
          Constant = "",
          Struct = "",
          Event = "",
          Operator = "",
          TypeParameter = "",
        },
      },

      snippets = { preset = "default" },

      completion = {
        documentation = { auto_show = true },
        ghost_text = { enabled = true },
        list = { selection = { preselect = false, auto_insert = true } },
      },
      sources = {
        default = {
          "lsp",
          "path",
          "snippets",
          "buffer",
          "nerdfont",
        },

        per_filetype = {},

        providers = {
          ripgrep = {
            name = "Ripgrep",
            module = "blink-ripgrep",
            enabled = true,
            score_offset = 1000, -- the higher the number, the higher the priority
            opts = {},
          },

          lsp = {
            name = "lsp",
            enabled = true,
            module = "blink.cmp.sources.lsp",
            score_offset = 2500, -- the higher the number, the higher the priority
          },

          snippets = {
            name = "snippets",
            enabled = true,
            module = "blink.cmp.sources.snippets",
            opts = {
              friendly_snippets = true,
              global_snippets = { "all" },
            },
          },
          nerdfont = {
            module = "blink-nerdfont",
            name = "Nerd Fonts",
            opts = { insert = true },
          },
        },
      },
      fuzzy = {
        implementation = "prefer_rust_with_warning",
        sorts = { "exact", "score", "sort_text" },
      },
    },
  },
}

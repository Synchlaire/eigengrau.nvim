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

        -- Navigation (prefer Alt for non-intrusive bindings)
        ["<A-j>"] = { "select_next", "fallback" },
        ["<A-k>"] = { "select_prev", "fallback" },
        ["<A-Tab>"] = { "select_next", "fallback" },
        ["<A-p>"] = { "select_prev", "fallback" },

        -- Jump by source (e.g., skip all LSP items to get to snippets)
        ["<A-n>"] = {
          function(cmp)
            return cmp.select_next({ jump_by = "source_id" })
          end,
          "fallback"
        },
        ["<A-N>"] = {
          function(cmp)
            return cmp.select_prev({ jump_by = "source_id" })
          end,
          "fallback"
        },

        -- Accept shortcuts
        ["<C-y>"] = { "accept", "fallback" }, -- Quick accept (muscle memory from default preset)
        ["<A-CR>"] = { "select_and_accept" }, -- Accept first if none selected

        -- Documentation
        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
        ["<C-d>"] = { "show_documentation", "hide_documentation" }, -- Toggle docs

        -- Signature help
        ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
        ["<C-S-k>"] = { "scroll_signature_up", "fallback" },
        ["<C-S-j>"] = { "scroll_signature_down", "fallback" },

        -- Provider-specific completions
        ["<C-g>"] = {
          function(cmp)
            cmp.show({ providers = { "ripgrep" } })
          end,
        },
        ["<C-s>"] = {
          function(cmp)
            cmp.show({ providers = { "snippets" } })
          end,
        },
        ["<C-l>"] = { -- LSP-only (useful in large codebases)
          function(cmp)
            cmp.show({ providers = { "lsp" } })
          end,
        },
        ["<C-p>"] = { -- Path completion
          function(cmp)
            cmp.show({ providers = { "path" } })
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
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200, -- Slight delay to avoid distraction
          window = {
            max_width = 60,
            max_height = 20,
            border = "rounded",
          },
        },
        ghost_text = {
          enabled = true,
        },
        menu = {
          max_height = 15, -- Don't let completion menu dominate screen
          border = "rounded",
          draw = {
            columns = {
              { "label", "label_description", gap = 1 },
              { "kind_icon", "kind", gap = 1 },
            },
          },
        },
        list = {
          selection = {
            preselect = false, -- Don't auto-select first item (good for "enter" preset)
            auto_insert = true, -- Insert on select (preview as you navigate)
          },
          cycle = {
            from_bottom = true, -- Wrap to top when going down from last
            from_top = true, -- Wrap to bottom when going up from first
          },
        },
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
            score_offset = 500,
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

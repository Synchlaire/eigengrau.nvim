return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      { "MunifTanjim/nui.nvim", event = "VeryLazy" },
    },
    config = function()
      require("noice").setup({
        -- Disable Noice notifications (often used to prevent conflicts)
        notify = {
          enabled = false,
        },

        cmdline = {
          enabled = true,
          view = "cmdline",
          opts = {},
          format = {
            cmdline = { pattern = "^:", icon = "", lang = "vim" },
            search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
            search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
            filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
            lua = {
              pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" },
              icon = "",
              lang = "lua",
            },
            help = { pattern = "^:%s*he?l?p?%s+", icon = "" },
            input = {},
          },
        },

        routes = {
          {
            view = "notify",
            filter = { event = "msg_showmode" },
          },
          {
            filter = {
              event = "msg_show",
              kind = "",
              find = "written",
            },
            opts = { skip = true },
          },
        },

        lsp = {
          progress = {
            enabled = true,
            format = "lsp_progress",
            format_done = "lsp_progress_done",
            throttle = 1000 / 30,
            view = "mini",
          },
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
          hover = {
            enabled = true,
            silent = false,
            view = nil,
            opts = {},
          },
          signature = {
            enabled = true,
            auto_open = {
              enabled = true,
              trigger = true,
              luasnip = true,
              throttle = 50,
            },
            view = nil,
            opts = {},
          },
          messages = {
            enabled = true,
            view = "notify",
            view_error = "notify",
            view_warn = "virtualtext",
            view_history = "messages",
            view_search = "virtualtext",
            opts = {},
          },
          popupmenu = {
            enabled = true,
            backend = "cmp",
          },
          documentation = {
            view = "hover",
            opts = {
              lang = "markdown",
              replace = true,
              render = "plain",
              format = { "{message}" },
              win_options = { concealcursor = "n", conceallevel = 1 },
            },
          },
        },

        markdown = {
          hover = {
            ["|(%S-)|"] = vim.cmd.help,
            ["%[.-%]%((%S-)%)"] = require("noice.util").open,
          },
          highlights = {
            ["|%S-|"] = "@text.reference",
            ["@%S+"] = "@parameter",
            ["^%s*(Parameters:)"] = "@text.title",
            ["^%s*(Return:)"] = "@text.title",
            ["^%s*(See also:)"] = "@text.title",
            ["{%S-}"] = "@parameter",
          },
        },

        health = {
          checker = true,
        },

        smart_move = {
          enabled = true,
          excluded_filetypes = { "cmp_menu", "cmp_docs", "notify" },
        },

        presets = {
          bottom_search = false,
          command_palette = false,
          long_message_to_split = true,
          inc_rename = true,
          lsp_doc_border = true,
        },
      })

      -- Keymap definition
      vim.keymap.set("c", "<S-Enter>", function()
        require("noice").redirect(vim.fn.getcmdline())
      end, { desc = "Redirect Cmdline" })
    end,
  },
}

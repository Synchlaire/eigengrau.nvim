-- Streamlined LSP configuration (Neovim 0.11+ API)
-- Languages: Lua, Bash, Markdown, Typst

return {
  -- Mason LSP installer (load first)
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    lazy = true,
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = { "lua_ls", "bashls", "tinymist", "harper_ls" },
      automatic_installation = true,
      handlers = {
        -- Default handler - setup all servers with new API
        function(server_name)
          local capabilities =
              require("blink.cmp").get_lsp_capabilities()

          vim.lsp.config[server_name] = {
            capabilities = capabilities,
          }

          vim.lsp.enable(server_name)
        end,

        -- Custom handler for lua_ls
        ["lua_ls"] = function()
          local capabilities =
              require("blink.cmp").get_lsp_capabilities()

          vim.lsp.config.lua_ls = {
            capabilities = capabilities,
            settings = {
              Lua = {
                diagnostics = { globals = { "vim" } },
                workspace = {
                  library = { vim.env.VIMRUNTIME },
                  checkThirdParty = false,
                },
                telemetry = { enable = false },
                format = { enable = false }, -- Use stylua instead
              },
            },
          }

          vim.lsp.enable("lua_ls")
        end,

        -- Harper-ls for grammar/spelling (Spanish + English)
        ["harper_ls"] = function()
          local capabilities =
              require("blink.cmp").get_lsp_capabilities()

          vim.lsp.config.harper_ls = {
            capabilities = capabilities,
            filetypes = { "markdown", "text", "gitcommit" },
            settings = {
              ["harper-ls"] = {
                -- Language dialect (supports: "Spanish", "American", "British", "Australian", "Canadian")
                dialect = "American",  -- Change to "Spanish" for Spanish-only

                -- User dictionary path (add your own words)
                userDictPath = vim.fn.stdpath("config") .. "/spell/harper_dict.txt",

                -- Linters to enable/disable
                linters = {
                  spell_check = true,
                  spelled_numbers = false,
                  an_a = true,
                  sentence_capitalization = true,
                  unclosed_quotes = true,
                  wrong_quotes = false,
                  long_sentences = true,
                  repeated_words = true,
                  spaces = true,
                  matcher = true,
                  correct_number_suffix = true,
                  number_suffix_capitalization = true,
                  multiple_sequential_pronouns = true,
                  linking_verbs = false,  -- Can be noisy
                  avoid_curses = false,   -- You curse, we know
                },

                -- Code action behavior
                codeActions = {
                  forceStable = true,
                },
              },
            },
          }

          vim.lsp.enable("harper_ls")
        end,
      },
    },
  },

  -- LSP client configuration
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "williamboman/mason-lspconfig.nvim" },
    config = function()
      -- Minimal diagnostic configuration
      vim.diagnostic.config({
        virtual_text = { prefix = "●" },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.HINT] = "",
            [vim.diagnostic.severity.INFO] = "",
          },
        },
        float = { border = "rounded" },
      })

      -- LSP keymaps (only on attach)
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local map = function(keys, func, desc)
            vim.keymap.set(
              "n",
              keys,
              func,
              { buffer = ev.buf, desc = desc }
            )
          end

          -- Navigation
          map("gd", vim.lsp.buf.definition, "Go to definition")
          map("gD", vim.lsp.buf.declaration, "Go to declaration")
          map("gr", vim.lsp.buf.references, "Show references")
          map(
            "gI",
            vim.lsp.buf.implementation,
            "Go to implementation"
          )

          -- Actions
          map("K", vim.lsp.buf.hover, "Hover documentation")
          map("<leader>la", vim.lsp.buf.code_action, "Code action")
          map("<leader>lr", vim.lsp.buf.rename, "Rename symbol")

          -- Diagnostics
          map("[d", function()
            vim.diagnostic.jump({ count = -1, float = true })
          end, "Previous diagnostic")
          map("]d", function()
            vim.diagnostic.jump({ count = 1, float = true })
          end, "Next diagnostic")
          map(
            "<leader>ld",
            vim.diagnostic.open_float,
            "Show diagnostics"
          )
        end,
      })
    end,
  },
}

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
      ensure_installed = {
        "lua_ls",
        "bashls",
        "tinymist",
        -- "harper_ls"
      },
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

        -- Harper-ls: Don't auto-enable, configured via lspconfig below
        ["harper_ls"] = function()
          -- Empty handler, we'll use lspconfig.setup() in nvim-lspconfig config
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

      -- Harper-ls: Disabled until proper 0.11+ migration
      -- TODO: Migrate to vim.lsp.config API when ready

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

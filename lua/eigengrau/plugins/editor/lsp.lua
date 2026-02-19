-- LSP configuration using Neovim 0.11+ native vim.lsp.config/vim.lsp.enable API
-- Languages: Lua, Bash, Python, Typst

return {
  -- Mason LSP installer (load first)
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    lazy = true,
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = {
        "bashls",
        "ruff",
        "lua_ls",
        "tinymist",
        "basedpyright",
      },
      automatic_enable = false, -- Disable auto vim.lsp.enable() (we handle it manually below)
    },
  },

  -- LSP client configuration
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "williamboman/mason-lspconfig.nvim" },
    config = function()
      -- Get capabilities from blink.cmp
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      -- Minimal diagnostic configuration
      vim.diagnostic.config({
        virtual_text = false, -- Disable inline diagnostic messages
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

      -- Server configurations using NEW vim.lsp.config API (0.11+)
      local servers = {
        lua_ls = {
          capabilities = capabilities,
        },
        bashls = {
          capabilities = capabilities,
        },
        ruff = {
          capabilities = capabilities,
          init_options = {
            settings = {
              lineLength = 88,
            },
          },
        },
        basedpyright = {
          capabilities = capabilities,
          settings = {
            basedpyright = {
              analysis = {
                typeCheckingMode = "standard",
              },
            },
          },
        },
        tinymist = {
          capabilities = capabilities,
        },
      }

      -- Setup all servers using new API with error handling
      for server, config in pairs(servers) do
        local ok, err = pcall(function()
          vim.lsp.config(server, config)
          vim.lsp.enable(server)
        end)
        if not ok then
          vim.notify(
            string.format("Failed to setup %s: %s", server, err),
            vim.log.levels.ERROR
          )
        end
      end

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
          map("gI", vim.lsp.buf.implementation, "Go to implementation")

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
          map("<leader>ld", vim.diagnostic.open_float, "Show diagnostics")
        end,
      })
    end,
  },
}

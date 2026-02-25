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
        "jsonls",
        "yamlls",
        "taplo",
        "marksman",
      },
      automatic_enable = true, -- Disable auto vim.lsp.enable() (we handle it manually below)
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

      -- Diagnostic configuration with icons
      vim.diagnostic.config({
        virtual_text = false, -- Let diagflow.nvim handle inline display
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = " ",
            [vim.diagnostic.severity.INFO] = " ",
          },
        },
        severity_sort = true,
        update_in_insert = false,
        float = { border = "rounded", source = "if_many" },
      })

      -- Server configurations using NEW vim.lsp.config API (0.11+)
      local servers = {
        lua_ls = {
          capabilities = capabilities,
        },
        hyperls = {
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
                disableOrganizeImports = true,
              },
            },
          },
        },
        jsonls = { capabilities = capabilities },
        yamlls = { capabilities = capabilities },
        taplo = { capabilities = capabilities },
        marksman = { capabilities = capabilities },
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

      -- Inlay hints toggle (global)
      vim.keymap.set("n", "<leader>th", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
      end, { desc = "Toggle inlay hints" })

      -- LSP restart
      vim.keymap.set("n", "<leader>lR", "<cmd>LspRestart<cr>", {
        desc = "Restart LSP",
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

          local client = vim.lsp.get_client_by_id(ev.data.client_id)

          -- Navigation
          map("gd", vim.lsp.buf.definition, "Go to definition")
          map("gD", vim.lsp.buf.declaration, "Go to declaration")
          map("gr", vim.lsp.buf.references, "Show references")
          map("gI", vim.lsp.buf.implementation, "Go to implementation")

          -- Actions
          map("K", vim.lsp.buf.hover, "Hover documentation")
          map("gs", vim.lsp.buf.signature_help, "Signature help")
          map("<leader>la", vim.lsp.buf.code_action, "Code action")
          map("<leader>lr", vim.lsp.buf.rename, "Rename symbol")
          map("<leader>lS", vim.lsp.buf.workspace_symbol, "Workspace symbols")

          -- Diagnostics
          map("[d", function()
            vim.diagnostic.jump({ count = -1, float = true })
          end, "Previous diagnostic")
          map("]d", function()
            vim.diagnostic.jump({ count = 1, float = true })
          end, "Next diagnostic")
          map("<leader>ld", vim.diagnostic.open_float, "Show diagnostics")

          -- Inlay hints (per-buffer)
          if client and client.supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
          end

          -- Document highlight (highlight word under cursor)
          if client and client.supports_method("textDocument/documentHighlight") then
            local hl_group = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = false })
            vim.api.nvim_clear_autocmds({ buffer = ev.buf, group = hl_group })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = ev.buf,
              group = hl_group,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = ev.buf,
              group = hl_group,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })
    end,
  },
}

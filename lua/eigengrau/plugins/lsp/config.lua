-- Comprehensive LSP configuration (Neovim 0.11+ API)
-- Languages: Lua, Bash, JSON, Markdown, Typst, Python

return {
  -- Mason LSP installer (load first)
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    lazy = true,
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = {
        -- Core languages
        "lua_ls",        -- Lua
        "bashls",        -- Bash
        "jsonls",        -- JSON
        "marksman",      -- Markdown
        "tinymist",      -- Typst
        "basedpyright",  -- Python (faster than pyright)
      },
      automatic_installation = true,
      handlers = {
        -- Default handler - setup all servers with new API
        function(server_name)
          local capabilities = require("blink.cmp").get_lsp_capabilities()

          vim.lsp.config[server_name] = {
            capabilities = capabilities,
          }

          vim.lsp.enable(server_name)
        end,

        -- Lua LSP
        ["lua_ls"] = function()
          local capabilities = require("blink.cmp").get_lsp_capabilities()

          vim.lsp.config.lua_ls = {
            capabilities = capabilities,
            settings = {
              Lua = {
                runtime = { version = "LuaJIT" },
                diagnostics = {
                  globals = { "vim" },
                  disable = { "missing-fields" },
                },
                workspace = {
                  library = {
                    vim.env.VIMRUNTIME,
                    "${3rd}/luv/library",
                  },
                  checkThirdParty = false,
                },
                telemetry = { enable = false },
                format = { enable = false }, -- Use stylua instead
                hint = {
                  enable = true,
                  setType = true,
                },
              },
            },
          }

          vim.lsp.enable("lua_ls")
        end,

        -- Bash LSP
        ["bashls"] = function()
          local capabilities = require("blink.cmp").get_lsp_capabilities()

          vim.lsp.config.bashls = {
            capabilities = capabilities,
            filetypes = { "sh", "bash", "zsh" },
            settings = {
              bashIde = {
                globPattern = "*@(.sh|.inc|.bash|.command|.zsh)",
              },
            },
          }

          vim.lsp.enable("bashls")
        end,

        -- JSON LSP
        ["jsonls"] = function()
          local capabilities = require("blink.cmp").get_lsp_capabilities()

          vim.lsp.config.jsonls = {
            capabilities = capabilities,
            settings = {
              json = {
                schemas = require("schemastore").json.schemas(),
                validate = { enable = true },
                format = { enable = true },
              },
            },
          }

          vim.lsp.enable("jsonls")
        end,

        -- Markdown LSP
        ["marksman"] = function()
          local capabilities = require("blink.cmp").get_lsp_capabilities()

          vim.lsp.config.marksman = {
            capabilities = capabilities,
            filetypes = { "markdown", "markdown.mdx" },
          }

          vim.lsp.enable("marksman")
        end,

        -- Python LSP (basedpyright)
        ["basedpyright"] = function()
          local capabilities = require("blink.cmp").get_lsp_capabilities()

          vim.lsp.config.basedpyright = {
            capabilities = capabilities,
            settings = {
              basedpyright = {
                analysis = {
                  typeCheckingMode = "standard",
                  autoSearchPaths = true,
                  useLibraryCodeForTypes = true,
                  diagnosticMode = "workspace",
                  autoImportCompletions = true,
                },
              },
            },
          }

          vim.lsp.enable("basedpyright")
        end,

        -- Typst LSP (tinymist)
        ["tinymist"] = function()
          local capabilities = require("blink.cmp").get_lsp_capabilities()

          vim.lsp.config.tinymist = {
            capabilities = capabilities,
            settings = {
              exportPdf = "onSave",
              outputPath = "$root/target/$dir/$name",
            },
          }

          vim.lsp.enable("tinymist")
        end,
      },
    },
  },

  -- JSON schemas for jsonls
  {
    "b0o/schemastore.nvim",
    lazy = true,
    ft = "json",
  },

  -- LSP client configuration
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "b0o/schemastore.nvim",
    },
    config = function()
      -- Enhanced diagnostic configuration
      vim.diagnostic.config({
        virtual_text = {
          prefix = "●",
          spacing = 4,
          source = "if_many",
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.HINT] = "",
            [vim.diagnostic.severity.INFO] = "",
          },
        },
        float = {
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

      -- LSP keymaps (only on attach)
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = ev.buf, desc = desc })
          end

          -- Navigation
          map("gd", vim.lsp.buf.definition, "Go to definition")
          map("gD", vim.lsp.buf.declaration, "Go to declaration")
          map("gr", vim.lsp.buf.references, "Show references")
          map("gI", vim.lsp.buf.implementation, "Go to implementation")
          map("gy", vim.lsp.buf.type_definition, "Go to type definition")

          -- Documentation
          map("K", vim.lsp.buf.hover, "Hover documentation")
          map("gK", vim.lsp.buf.signature_help, "Signature help")

          -- Actions
          map("<leader>la", vim.lsp.buf.code_action, "Code action")
          map("<leader>lr", vim.lsp.buf.rename, "Rename symbol")
          map("<leader>lf", vim.lsp.buf.format, "Format buffer")

          -- Diagnostics
          map("[d", function()
            vim.diagnostic.jump({ count = -1, float = true })
          end, "Previous diagnostic")
          map("]d", function()
            vim.diagnostic.jump({ count = 1, float = true })
          end, "Next diagnostic")
          map("<leader>ld", vim.diagnostic.open_float, "Show diagnostics")
          map("<leader>lq", vim.diagnostic.setloclist, "Diagnostics to loclist")

          -- Workspace
          map("<leader>lwa", vim.lsp.buf.add_workspace_folder, "Add workspace folder")
          map("<leader>lwr", vim.lsp.buf.remove_workspace_folder, "Remove workspace folder")
          map("<leader>lwl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, "List workspace folders")
        end,
      })
    end,
  },
}

-- Comprehensive formatter configuration with prettier support
-- Covers: Lua, Shell, Python, JSON, Markdown, Typst

return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason.nvim",
  },
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        -- Lua
        lua = { "stylua" },

        -- Shell scripts
        sh = { "shfmt" },
        bash = { "shfmt" },
        zsh = { "shfmt" },

        -- Python (ruff is faster than black, does formatting + import sorting)
        python = { "ruff_format", "ruff_organize_imports" },

        -- Web & data formats (prettier)
        json = { "prettier" },
        jsonc = { "prettier" },
        markdown = { "prettier" },
        ["markdown.mdx"] = { "prettier" },
        yaml = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },

        -- Typst (LSP handles formatting)
        typst = { "tinymist" },
      },

      -- Formatter-specific configurations
      formatters = {
        -- Stylua for Lua
        stylua = {
          prepend_args = {
            "--indent-type", "Spaces",
            "--indent-width", "2",
            "--column-width", "120",
          },
        },

        -- Shfmt for shell scripts
        shfmt = {
          prepend_args = {
            "-i", "2",      -- 2-space indent
            "-ci",          -- indent switch cases
            "-bn",          -- binary ops like && and | may start a line
          },
        },

        -- Prettier configuration
        prettier = {
          prepend_args = {
            "--prose-wrap", "always",      -- Wrap prose (markdown)
            "--print-width", "88",         -- Match Black/Ruff line length
            "--tab-width", "2",
            "--use-tabs", "false",
            "--semi", "true",
            "--single-quote", "false",
            "--trailing-comma", "es5",
            "--bracket-spacing", "true",
            "--arrow-parens", "always",
          },
        },

        -- Ruff for Python (faster than black)
        ruff_format = {
          prepend_args = {
            "--line-length", "88",
          },
        },
      },

      -- Format on save (disabled by default - enable per-project or globally)
      format_on_save = function(bufnr)
        -- Disable for certain filetypes
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return
        end

        -- Disabled by default - uncomment to enable
        -- return {
        --   timeout_ms = 500,
        --   lsp_fallback = true,
        -- }
      end,
    })

    -- Keymaps for formatting
    vim.keymap.set({ "n", "v" }, "<leader>lf", function()
      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      })
    end, { desc = "Format buffer/selection" })

    -- Format entire buffer (force async for large files)
    vim.keymap.set("n", "<leader>lF", function()
      conform.format({
        lsp_fallback = true,
        async = true,
        timeout_ms = 3000,
      })
    end, { desc = "Format buffer (async)" })

    -- Show formatter info for current buffer
    vim.keymap.set("n", "<leader>li", function()
      local formatters = conform.list_formatters(0)
      if #formatters == 0 then
        vim.notify("No formatters available for this filetype", vim.log.levels.INFO)
        return
      end

      local info = { "Available formatters:" }
      for _, formatter in ipairs(formatters) do
        table.insert(info, string.format("  • %s (%s)", formatter.name, formatter.available and "available" or "not available"))
      end

      vim.notify(table.concat(info, "\n"), vim.log.levels.INFO, { title = "Formatters" })
    end, { desc = "Show formatter info" })

    -- Auto-install formatters via Mason
    local ensure_installed = {
      "stylua",      -- Lua
      "shfmt",       -- Shell
      "prettier",    -- JSON, Markdown, etc.
      "ruff",        -- Python
    }

    -- Register Mason ensure_installed
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        local registry = require("mason-registry")
        for _, tool in ipairs(ensure_installed) do
          local p = registry.get_package(tool)
          if not p:is_installed() then
            vim.notify(string.format("Installing formatter: %s", tool), vim.log.levels.INFO)
            p:install()
          end
        end
      end,
    })
  end,
}

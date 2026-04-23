-- Code formatter using conform.nvim
-- Languages: Lua, Bash, Python, Markdown, Typst

return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")
    if vim.g.format_on_save_enabled == nil then
      vim.g.format_on_save_enabled = true
    end

    conform.setup({
      formatters_by_ft = {
        lua = { "stylua" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        python = { "ruff_format" }, -- Uses ruff for formatting (fast!)
        markdown = { "prettier" }, -- Optional: format markdown tables/lists
        typst = { "tinymist" },
      },

      formatters = {
        shfmt = {
          prepend_args = { "-i", "2", "-ci" }, -- 2-space indent, indent switch cases
        },
        ruff_format = {
          command = "ruff",
          args = { "format", "--stdin-filename", "$FILENAME", "-" },
          stdin = true,
        },
      },

      -- Format on save (can toggle with <leader>tf)
      format_on_save = function(bufnr)
        -- Check if format on save is disabled globally
        if not vim.g.format_on_save_enabled then
          return
        end
        -- Disable for certain filetypes if needed
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return
        end
        return {
          timeout_ms = 500,
          lsp_fallback = true,
        }
      end,
    })

    -- Manual format keymap
    vim.keymap.set({ "n", "v" }, "<leader>lf", function()
      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      })
    end, { desc = "Format buffer/selection" })

    -- Toggle for format on save is in snacks.lua via Snacks.toggle
  end,
}

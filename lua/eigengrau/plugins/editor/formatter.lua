-- Minimal formatter configuration
-- Only for: Lua, Shell, Markdown, Typst

return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        lua = { "stylua" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        typst = { "tinymist" },
        -- Markdown: use prose formatting tools instead (<leader>pc, <leader>pj)
        -- Typst: LSP handles formatting
      },

      formatters = {
        shfmt = {
          prepend_args = { "-i", "2", "-ci" }, -- 2-space indent, indent switch cases
        },
      },
    })

    -- Manual format keymap
    vim.keymap.set({ "n", "v" }, "<leader>lf", function()
      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      })
    end, { desc = "Format buffer/selection" })
  end,
}

return {
  {
    "williamboman/mason.nvim",
    lazy = true,
    cmd = "Mason",
    event = "BufReadPre",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = true,
    event = "BufReadPre",
    opts = {
      auto_install = true,
      ensure_installed = {
	"lua_ls",
	"typst_lsp",
      }
    },
  },
  {
    "neovim/nvim-lspconfig",
    lazy = true,
    event = "BufReadPre",
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      local lspconfig = require("lspconfig")
      lspconfig.lua_ls.setup({
	capabilities = capabilities
      })
      lspconfig.typst_lsp.setup({
	capabilities = capabilities,
	settings = {
	  --	  exportPdf = "onType"
	}
      })
--      lspconfig.markdown_oxide.setup({
--	capabilities = vim.tbl_deep_extend(
--	  'force',
--	  capabilities,
--	  {
--	    workspace = {
--	      didChangeWatchedFiles = {
--		dynamicRegistration = true,
--	      },
--	    },
--	  }
--	),
-- on_attach = on_attach -- configure your on attach config
--      })

      vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "hover lsp window"})
      vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "go to definition"})
      vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { desc = "go to references" })
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "code action"})
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {desc = "rename"})
    end,
  },
}

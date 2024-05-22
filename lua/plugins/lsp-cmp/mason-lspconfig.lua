local options = {
  automatic_installation = false,
}

local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

require("mason-lspconfig").setup(options)

local options = {
  ensure_installed = {
    "bash-language-server",
    "css-lsp",
    "gitlint",
    "jq",
    "json-lsp",
    "jsonlint",
    "lua-language-server",
    "luacheck",
    "stylua",
    "markdownlint",
    "marksman",
    "markuplint",
    "prettierd",
    "pyright",
    "shellcheck",
    "vim-language-server",
    "yaml-language-server",
    "yamlfmt",
    "yamllint",
  },
  max_concurrent_installers = 10,
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
}

require("mason").setup(options)

vim.api.nvim_create_user_command("MasonInstallAll", function()
  vim.cmd("MasonInstall " .. table.concat(options.ensure_installed, " "))
end, {})

---@diagnostic disable: undefined-field
-- Ensure lazy.nvim is installed

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

-- Leader keys
vim.g.mapleader = " "

-- Core settings
--require("eigengrau.components.init")
require("eigengrau.config.neovide")
require("eigengrau.config.functions")
require("eigengrau.config.options")
require("eigengrau.config.keymaps")
require("eigengrau.config.aliases")
require("eigengrau.config.autocmds")

-- Plugin imports (organized by load priority)
local plugins = {
  { import = "eigengrau.plugins.core" },              -- Startup essentials
  { import = "eigengrau.plugins.core.colorschemes" }, -- colorschemes duh
  { import = "eigengrau.plugins.early" },             -- Early loading (UI, treesitter)
  { import = "eigengrau.plugins.editor" },            -- Editor features (LSP, completion)
  { import = "eigengrau.plugins.editor.writing" },    -- prose writing tools
  { import = "eigengrau.plugins.tools" },             -- On-demand tools
  { import = "eigengrau.plugins.optional" },          -- Optional features
}

-- Lazy setup
require("lazy").setup(plugins, {
  checker = {
    enabled = false,
    notify = false,
  },
  ui = {
    size = { width = 0.8, height = 0.8 },
    border = "solid",
  },
  change_detection = {
    enabled = true,
    notify = false,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "node_provider",
        "ruby_provider",
        "perl_provider",
        "2html_plugin",
        "getscript",
        "getscriptPlugin",
        --        "gzip",
        --        "tar",
        --        "tarPlugin",
        "rrhelper",
        "vimball",
        "vimballPlugin",
        --        "zip",
        --        "zipPlugin",
        "tutor",
        "rplugin",
        "logiPat",
        "bugreport",
        "netrw",
        "netrwPlugin",
        "netrwSettings",
      },
    },
  },
})

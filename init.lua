---@diagnostic disable: undefined-field
-- Enable the experimental Lua module loader for faster startup
if vim.loader then
  vim.loader.enable()
end

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

-- Disable unused language providers (silences checkhealth warnings, faster startup)
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

-- Force Ghostty detection for Snacks.image (TERM=xterm-ghostty misdetects)
if vim.env.GHOSTTY_RESOURCES_DIR or (vim.env.TERM or ""):find("ghostty") then
  vim.env.SNACKS_GHOSTTY = "1"
end

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
  { import = "eigengrau.plugins.core" },           -- Startup essentials
  { import = "eigengrau.plugins.early" },          -- Early loading (UI, treesitter)
  { import = "eigengrau.plugins.ui" },             -- UI enhancements
  { import = "eigengrau.plugins.editor" },         -- Editor features (LSP, completion)
  { import = "eigengrau.plugins.editor.writing" }, -- Prose writing tools
  { import = "eigengrau.plugins.tools" },          -- Utilities & navigation
}

-- Lazy setup
require("lazy").setup(plugins, {
  rocks = { enabled = false }, -- No plugins need luarocks; silences hererocks warnings
  checker = {
    enabled = true,
    notify = true,
  },
  ui = {
    size = { width = 0.5, height = 0.8 },
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
        "gzip",
        "tar",
        "tarPlugin",
        "rrhelper",
        "vimball",
        "vimballPlugin",
        "zip",
        "zipPlugin",
        "tohtml",
        "matchit",
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

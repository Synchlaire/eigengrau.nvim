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

-- Ensure API keys from shell environment are accessible
if not os.getenv("GEMINI_API_KEY") then
  -- Try reading directly from shell config file (for neovide + GUI launches)
  local shell_config = os.getenv("HOME") .. "/.config/shell/vars.zsh"
  local file = io.open(shell_config, "r")
  if file then
    local content = file:read("*a")
    file:close()
    -- Extract GEMINI_API_KEY from export line
    local key = content:match('export%s+GEMINI_API_KEY%s*=%s*"([^"]+)"')
    if key and key ~= "" then
      vim.env.GEMINI_API_KEY = key
    end
  end
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
  { import = "eigengrau.plugins.core" },              -- Startup essentials
  { import = "eigengrau.plugins.core.colorschemes" }, -- Colorschemes
  { import = "eigengrau.plugins.early" },             -- Early loading (UI, treesitter)
  { import = "eigengrau.plugins.ui" },                -- UI enhancements
  { import = "eigengrau.plugins.editor" },            -- Editor features (LSP, completion)
  { import = "eigengrau.plugins.editor.writing" },    -- Prose writing tools
  { import = "eigengrau.plugins.tools" },             -- Utilities & navigation
  { import = "eigengrau.plugins.ai" },                -- AI tools
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

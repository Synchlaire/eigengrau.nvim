vim.loader.disable()
-- Ensure lazy.nvim is installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

-- leader keys
vim.g.mapleader = " "
--vim.g.maplocalleader = ";"

-- Lazy.nvim setup

-- plugins
local plugins = {
  { import = "eigengrau.plugins"},
  { import = "eigengrau.plugins.colors"},
  { import = "eigengrau.plugins.markdown"},
  { import = "eigengrau.plugins.ui"},
  { import = "eigengrau.plugins.dev"},
  { import = "eigengrau.plugins.utils"},

}


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
    -- automatically check for config file changes and reload the ui
    enabled = true,
    notify = false, -- get a notification when changes are found
  },

  -- disabled plugins
  performance = {
    rtp = {
      disabled_plugins = {
	--            "python_provider",
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
	"tutor",
	"rplugin",
	"logiPat",
	--            "shada",
	--            "syntax",
	--            "synmenu",
	--           "optwin",
	--            "compiler",
	"bugreport",
	--           "ftplugin",
	--          "load_ftplneugin",
	"indent_on",
	"netrw",                  -- disable builtin file manager
	"netrwPlugin",            -- disable builtin file manager
	"netrwSettings",
	"netrwFileHandlers",
      },
    },
  },
})

-- core
require("eigengrau.core.options")
require("eigengrau.core.keymaps")
require("eigengrau.core.aliases")
require("eigengrau.core.autocmds")

---- override default theme colors
--function ColorMyPencils()
--  vim.api.nvim_set_hl(0, "StatusLine", { bg = "None" })
--  vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "None" })
--  vim.api.nvim_set_hl(0, "Normal", { bg = "None" })
--  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "None" })
--  vim.api.nvim_set_hl(0, "Pmenu", { bg = "None" })
--  vim.api.nvim_set_hl(0, "SignColumn", { bg = "None" })
--  vim.api.nvim_set_hl(0, "FoldColumn", { bg = "None" })
--  vim.api.nvim_set_hl(0, "TabLineFill", { bg = "None" })
--  vim.api.nvim_set_hl(0, "TabLine", { bg = "None" })
--end
--
--ColorMyPencils()


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
vim.g.maplocalleader = ";"

-- Lazy.nvim setup
local plugins = {
    { import = "eigengrau.plugins"},
}

require("lazy").setup(plugins,
{
    checker = {
        enabled = false,
        notify = false,
    },
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
            "netrwSettings",
            "netrwFileHandlers",
            "syntax",
            "synmenu",
            "optwin",
            "compiler",
            "bugreport",
--           "ftplugin",
--          "load_ftplugin",
            "indent_on",
            "netrw",                  -- disable builtin file manager
            "netrwPlugin",            -- disable builtin file manager
        },
    },
},
})

-- core
vim.loader.enable()
vim.cmd[[colorscheme plain]]
require("eigengrau.core")
-- TODO: gotta add an lsp

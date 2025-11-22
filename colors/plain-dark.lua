-- Plain colorscheme - Dark variant (forces dark background)
vim.o.background = "dark"
dofile(vim.fn.stdpath("config") .. "/colors/plain.lua").setup("dark")
vim.g.colors_name = "plain-dark"

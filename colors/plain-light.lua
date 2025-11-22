-- Plain colorscheme - Light variant (forces light background)
vim.o.background = "light"
dofile(vim.fn.stdpath("config") .. "/colors/plain.lua").setup("light")
vim.g.colors_name = "plain-light"

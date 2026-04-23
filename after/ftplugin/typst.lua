-- Typst-specific settings
vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.spell = true
vim.opt_local.spelllang = { "en", "es" }
vim.opt_local.textwidth = 80
vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.expandtab = true

-- Prose treatment: indent soft-wrapped continuations and let j/k
-- traverse visual lines instead of jumping over wrapped paragraphs.
vim.opt_local.breakindent = true
vim.opt_local.breakindentopt = "shift:2"
vim.keymap.set("n", "j", "gj", { buffer = true, silent = true })
vim.keymap.set("n", "k", "gk", { buffer = true, silent = true })

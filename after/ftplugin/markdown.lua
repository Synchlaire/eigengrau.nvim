-- Markdown-specific settings
vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.spell = true
vim.opt_local.spelllang = { "en", "es" }
vim.opt_local.textwidth = 88
vim.opt_local.conceallevel = 2
vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.expandtab = true

-- Markdown-specific keymaps
vim.keymap.set("n", "<localleader>p", "<cmd>MarkdownPreview<CR>", {
  buffer = true,
  desc = "Markdown preview",
})

vim.keymap.set("n", "<localleader>t", "<cmd>ObsidianTags<CR>", {
  buffer = true,
  desc = "Search tags",
})

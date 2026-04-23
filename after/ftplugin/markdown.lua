-- Markdown-specific settings
vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.spell = true
vim.opt_local.spelllang = { "en", "es" }
vim.opt_local.textwidth = 80
vim.opt_local.conceallevel = 2
vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.expandtab = true

-- Format options: allow gq reformatting (`q`), continue comments on Enter
-- (`c`), but DON'T auto-continue them on `o`/`O`. Crucially, we do NOT add
-- `t` (auto-wrap text on type) — that flag makes every keystroke past
-- textwidth break the line, which feels laggy in prose. Use `gq` or
-- save-time autoformat (`<leader>pa`) instead.
vim.opt_local.formatoptions:append("cq")
vim.opt_local.formatoptions:remove("t")
vim.opt_local.formatoptions:remove("o")

-- Visual prose niceties
vim.opt_local.breakindent = true
vim.opt_local.breakindentopt = "shift:2"
vim.opt_local.list = false
vim.opt_local.cursorline = false
vim.opt_local.concealcursor = "nc"
vim.opt_local.spelloptions = "camel"

-- Heading folding via treesitter foldexpr. We compute folds once on
-- BufEnter and then switch to `manual` so cursor moves don't re-run the
-- foldexpr (which is the main cost on long notes). `zx` recomputes when
-- you actually need it. `foldlevel = 99` keeps everything open at start.
vim.opt_local.foldlevel = 99
vim.opt_local.foldmethod = "expr"
vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.schedule(function()
  if vim.bo.filetype == "markdown" then
    pcall(function() vim.cmd("normal! zx") end)
    vim.opt_local.foldmethod = "manual"
  end
end)

-- Visual-line motion (j/k navigate soft-wrapped lines naturally)
vim.keymap.set("n", "j", "gj", { buffer = true, silent = true })
vim.keymap.set("n", "k", "gk", { buffer = true, silent = true })

-- Markdown-specific keymaps
vim.keymap.set("n", "<localleader>T", "<cmd>Obsidian tags<CR>", {
  buffer = true,
  desc = "Search tags",
})

-- Obsidian smart_action on <CR> — context-aware:
-- on a checkbox: cycles state; on [[link]]: follows; on [](url): opens;
-- otherwise falls through to a regular newline. Normal-mode only.
vim.keymap.set("n", "<CR>", function()
  local ok, obsidian = pcall(require, "obsidian")
  if ok and obsidian.util and obsidian.util.smart_action then
    obsidian.util.smart_action()
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", false)
  end
end, { buffer = true, silent = true, desc = "Obsidian: smart action" })

-- Explicit checkbox cycling alongside smart_action — useful when the
-- cursor isn't on a checkbox line yet but you want to convert the line.
vim.keymap.set("n", "<localleader>x", "<cmd>Obsidian toggle_checkbox<CR>", {
  buffer = true,
  silent = true,
  desc = "Obsidian: toggle checkbox",
})

-- Typora/Obsidian-style Ctrl shortcuts (via markdown-plus.nvim <Plug> mappings)
local bmap = function(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { buffer = true, silent = true, desc = desc })
end

bmap("n", "<C-b>", "<Plug>(MarkdownPlusBold)", "Bold")
bmap("x", "<C-b>", "<Plug>(MarkdownPlusBold)", "Bold")
bmap("i", "<C-b>", function()
  vim.cmd("stopinsert")
  require("markdown-plus").format.toggle_format_word("bold")
  vim.cmd("startinsert")
end, "Bold")

bmap("n", "<C-s>", "<Plug>(MarkdownPlusStrikethrough)", "Strikethrough")
bmap("x", "<C-s>", "<Plug>(MarkdownPlusStrikethrough)", "Strikethrough")

bmap("n", "<C-e>", "<Plug>(MarkdownPlusCode)", "Inline code")
bmap("x", "<C-e>", "<Plug>(MarkdownPlusCode)", "Inline code")

bmap("n", "<C-q>", "<Plug>(MarkdownPlusToggleQuote)", "Blockquote")
bmap("x", "<C-q>", "<Plug>(MarkdownPlusToggleQuote)", "Blockquote")

-- A sidebar with a tree-like outline of symbols from your code, powered by LSP
return {
  "hedyhli/outline.nvim",
  lazy = true,
  ft = "markdown",
  cmd = { "Outline", "OutlineOpen" },
  keys = {
    { "|", "<cmd>Outline<CR>", desc = "Toggle outline" },
  },
  opts = {
    symbol_folding = {
      -- Unfold entire symbol tree by default with false, otherwise enter a
      -- number starting from 1
      autofold_depth = false,
      -- autofold_depth = 1,
    },
  },
}

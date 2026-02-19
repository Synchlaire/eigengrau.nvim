return {
  "TheNoeTrevino/haunt.nvim",
  cmd = {
    "HauntAnnotate", "HauntDelete", "HauntClear", "HauntClearAll",
    "HauntNext", "HauntPrev", "HauntList", "HauntQf", "HauntQfAll",
  },
  keys = {
    { "<leader>ha", "<cmd>HauntAnnotate<cr>", desc = "Haunt: Annotate" },
    { "<leader>hd", "<cmd>HauntDelete<cr>", desc = "Haunt: Delete" },
    { "<leader>hl", "<cmd>HauntList<cr>", desc = "Haunt: List" },
    { "<leader>hn", "<cmd>HauntNext<cr>", desc = "Haunt: Next" },
    { "<leader>hp", "<cmd>HauntPrev<cr>", desc = "Haunt: Prev" },
  },
  opts = {
    per_branch_bookmarks = true,
    picker = "auto",
  },
}

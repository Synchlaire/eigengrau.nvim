return {
  "bngarren/checkmate.nvim",
  ft = "markdown",
  keys = {
    { "<leader>tkt", "<cmd>Checkmate toggle<cr>", desc = "Toggle todo" },
    { "<leader>tkn", "<cmd>Checkmate create<cr>", desc = "Create todo" },
    { "<leader>tkl", "<cmd>Checkmate select_todo<cr>", desc = "List todos" },
    { "<leader>tka", "<cmd>Checkmate archive<cr>", desc = "Archive todos" },
  },
  opts = {
    smart_toggle = { enabled = true },
    list_continuation = { enabled = true },
  },
}

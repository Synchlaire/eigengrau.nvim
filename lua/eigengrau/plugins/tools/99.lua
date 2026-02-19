return {
  "ThePrimeagen/99",
  cmd = { "ClaudeChat", "ClaudeExplain", "ClaudeHealth", "KimiHistory", "KimiActions" },
  keys = {
    { "<leader>99", desc = "99: Quick Actions Menu", mode = { "n", "v" } },
    { "<leader>iv", desc = "99: Send visual selection to Claude", mode = "v" },
    { "<leader>is", desc = "99: Stop all requests", mode = { "n", "v" } },
    { "<leader>ia", desc = "99: Ask Claude about buffer" },
    { "<leader>ie", desc = "99: Explain code", mode = "v" },
    { "<leader>ir", desc = "99: Refactor code", mode = "v" },
    { "<leader>it", desc = "99: Generate tests", mode = "v" },
    { "<leader>id", desc = "99: Generate docs", mode = "v" },
    { "<leader>if", desc = "99: Fix code", mode = "v" },
    { "<leader>ii", desc = "99: Review code", mode = "v" },
    { "<leader>ic", desc = "99: Chat with Claude" },
    { "<leader>ih", desc = "99: Query history" },
    { "<leader>iu", desc = "99: View logs" },
  },
  config = function()
    local _99 = require("99")
    require("eigengrau.config.functions.ai-provider").setup(_99)
  end,
}

return {
  "ravitemer/mcphub.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  build = "npm install -g mcp-hub@latest",
  cmd = "MCPHub",
  keys = {
    { "<leader>mh", "<cmd>MCPHub<cr>", desc = "MCP Hub" },
  },
  config = function()
    require("mcphub").setup({
      port = 37373,
      shutdown_delay = 1000,
    })
  end,
}

return {
  "DrKJeff16/project.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  lazy = true,
  cmd = { "Project" },
  keys = {
    { "<leader>fp", "<cmd>Project<cr>", desc = "Projects" },
  },
  config = function()
    require("project").setup({
      detection_methods = { "pattern", "lsp" },
      patterns = { ".git", "Makefile", "package.json", "Cargo.toml", "pyproject.toml" },
      show_hidden = false,
      silent_chdir = true,
      manual_mode = false,
    })
  end,
}

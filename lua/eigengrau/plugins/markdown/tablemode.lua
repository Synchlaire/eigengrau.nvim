return{
  "kicamon/markdown-table-mode.nvim",
  lazy = true,
  ft = "markdown",
  config = function()
    require('markdown-table-mode').setup()
  end
}

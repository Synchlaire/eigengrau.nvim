-- wing-peek.nvim — floating webview markdown preview with the wing-os
return {
  "Synchlaire/wing-peek.nvim",
  build = "deno task --quiet build:fast",
  ft = "markdown",
  keys = {
    {
      "<localleader>p",
      function()
        local peek = require("peek")
        if peek.is_open() then
          peek.close()
        else
          peek.open()
        end
      end,
      ft = "markdown",
      desc = "Markdown preview toggle",
    },
  },
  opts = {
    auto_load = true,
    close_on_bdelete = true,
    syntax = true,
    theme = "dark",
    update_on_change = true,
    app = "webview",
  },
  config = function(_, opts)
    require("peek").setup(opts)
  end,
}

return {
  "rcarriga/nvim-notify",
  config = function()
    local notify = require("notify")

    notify.setup({
      fps = 60,
      stages = "static",
      render = "minimal",
      timeout = 2500,
      top_down = false,
    })

    vim.notify = notify
  end,
}

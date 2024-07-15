return {
  "tversteeg/registers.nvim",
  cmd = "Registers",
  config = function()
    local registers = require("registers")
    registers.setup({
      bind_keys = {
	normal = false,
      },
    })
  end,
}


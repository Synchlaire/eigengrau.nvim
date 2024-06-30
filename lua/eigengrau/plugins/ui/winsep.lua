return {
  "nvim-zh/colorful-winsep.nvim",
  config = true,
  lazy = true,
  --cmd = { "WindowsMaximize", "WindowsMaximizeVertically", "WindowsMaximizeHorizontally", "WindowsEqualize" },
  config = function()
    require("colorful-winsep").setup({
      no_exec_files = { "lazy", "TelescopePrompt", "mason", "alpha" },
      anchor = {
	left = { height = 1, x = -1, y = -1 },
	right = { height = 1, x = -1, y = 0 },
	up = { width = 0, x = -1, y = 0 },
	bottom = { width = 0, x = 1, y = 0 },
      },
    })
  end
}

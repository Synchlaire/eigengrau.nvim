return {
  "nvim-zh/colorful-winsep.nvim",
  config = true,
  lazy = true,
  config = function()
    require("colorful-winsep").setup({
      highlight = {
	fg = vim.api.nvim_get_hl(0, { name = "lualine_a_insert" })["fg"],
	bg = vim.api.nvim_get_hl(0, { name = "EndofBuffer" })["bg"],
      },
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

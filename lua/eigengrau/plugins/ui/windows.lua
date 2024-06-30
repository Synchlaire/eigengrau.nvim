return {
  'anuvyklack/windows.nvim',
  dependencies = {
    'anuvyklack/middleclass',
    'anuvyklack/animation.nvim',
    'nvim-zh/colorful-winsep.nvim' },
  lazy = true,
  cmd = { "WindowsMaximize", "WindowsMaximizeVertically", "WindowsMaximizeHorizontally", "WindowsEqualize" },
  config = function()
    require("windows").setup({
      equalalways = false,
      autowidth = {
	enable = false,
	--                winwidth = 10,
	--                winminwidth = 10,
	filetype = { },
      },
      ignore = {
	buftype = { "quickfix"},
	filetype = { "NvimTree", "neo-tree", "undotree", "gundo" }
      },
      animation = {
	enable = true,
	duration = 200,
	fps = 60,
	easing = "in_out_sine"
      }
    })
  end
}

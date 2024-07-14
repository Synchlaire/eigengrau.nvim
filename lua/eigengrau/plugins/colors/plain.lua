return {
  --- plain
  'andreypopp/vim-colors-plain',
  lazy = true,
  event = {"ColorSchemePre"},
  config = function()
  --    vim.cmd[[colorscheme plain]]
  end

}
--  'haishanh/night-owl.vim', event = "Colorscheme",
--  'lamartire/hg.vim', event = "Colorscheme",
--  'lunarvim/templeos.nvim', event = "VeryLazy", -- chad mode
--  'relastle/bluewery.vim', event = "Colorscheme",
--  'sts10/vim-pink-moon', event = "Colorscheme",
--  'talha-akram/noctis.nvim', event = "Colorscheme",

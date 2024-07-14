return{
  "black-atom-industries/black-atom.nvim",
  lazy = true,
  event = {"ColorSchemePre"},


  pin = false,
--  dependencies = {
--    "black-atom-industries/black-atom-vault",
--    pin = true,
--    lazy = true
--  },
  opts = {
    debug = false,
    styles = {
      dark_sidebars = true,
      transparency = "none",
      cmp_kind_color_mode = "bg",
      diagnostics = {
	background = true,
      },
    },
  }
}

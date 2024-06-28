return{
  "black-atom-industries/black-atom.nvim",
  pin = true,
  lazy = false,
  dependencies = {
    "black-atom-industries/black-atom-vault",
    pin = true,
    lazy = false
  },
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

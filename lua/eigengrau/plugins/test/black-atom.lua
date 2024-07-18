---@type Huez.ThemeConfig
return{
  "black-atom-industries/black-atom.nvim",
  cmd = "Huez",
  dependencies = {
    "black-atom-industries/black-atom-vault",
--    pin = true,
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

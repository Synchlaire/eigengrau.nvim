return {
  "black-atom-industries/nvim",
  name = "black-atom",
  event = { "ColorSchemePre" }, -- if you want to lazy load
  enabled = false,
  opts = {
    -- Configuration options
    transparent = true, -- Enable transparent background
    contrast = false, -- Enable high contrast mode
  },
}

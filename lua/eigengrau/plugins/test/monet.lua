return {    --- monet
  'fynnfluegge/monet.nvim',
  cmd = "Huez",
  config = function()

---@type Huez.ThemeConfig
    require("monet").setup {
      transparent_background = false,
      semantic_tokens = true,
      dark_mode = true,
      highlight_overrides= {
	--        Normal = { fg = #c2f5bf },
	--        TelescopeMatching = { fg = #5cd5db },
      },
      color_overrides = {},
      styles = {
	strings = { "italic", "bold" },
      },
    }
  end,
}

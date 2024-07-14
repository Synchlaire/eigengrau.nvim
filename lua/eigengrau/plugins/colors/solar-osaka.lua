return {
  {
    "craftzdog/solarized-osaka.nvim",
    lazy = true,
    event = {"ColorSchemePre"},
    opts = function()
      return {
	transparent = false,
      }
    end,
  },
}

return {
  "xiyaowong/transparent.nvim",
  event = "VeryLazy",
  config = function()
    require("transparent").setup({
      groups = {
        "StatusLine",
        "StatusLineNC",
        "FocusBg",
        "NormalFloat",
        "Pmenu",
        "SignColumn",
        "FoldColumn",
        "TabLineFill",
        "TabLine",
        "WinBar",
      },
      exclude_groups = {},
    })
  end,
}

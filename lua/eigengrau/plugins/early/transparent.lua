return {
  "xiyaowong/transparent.nvim",
  lazy = false,
  priority = 9000,
  config = function()
    require("transparent").setup({
      groups = {
        "StatusLine",
        "StatusLineNC",
        "FocusBg",
        "ComposerNormal",
        "NormalFloat",
        "FloatBorder",
        "Pmenu",
        "SignColumn",
        "FoldColumn",
        "TabLineFill",
        "TabLine",
        "WinBar",
        "SnacksPickerBorder",
        "SnacksPickerInputBorder",
        "SnacksPickerPreviewBorder",
        "SnacksPickerBoxBorder",
      },
      exclude_groups = {},
    })
  end,
}

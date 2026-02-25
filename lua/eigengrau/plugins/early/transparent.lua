return {
  "xiyaowong/transparent.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("transparent").setup({
      groups = {
        "StatusLine",
        "StatusLineNC",
        "FocusBg",
        "NormalFloat",
        "FloatBorder",
        "Pmenu",
        "SignColumn",
        "FoldColumn",
        "TabLineFill",
        "TabLine",
        "WinBar",
        "RenderMarkdownH1Bg",
        "RenderMarkdownH2Bg",
        "RenderMarkdownH3Bg",
        "RenderMarkdownH4Bg",
        "RenderMarkdownH5Bg",
        "RenderMarkdownH6Bg",
        "SnacksPickerBorder",
        "SnacksPickerInputBorder",
        "SnacksPickerPreviewBorder",
        "SnacksPickerBoxBorder",
      },
      exclude_groups = {},
    })
  end,
}

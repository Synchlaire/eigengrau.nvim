return {
  --- nightfly
  'bluz71/vim-nightfly-colors',
  lazy = true,
  init = function()
    local g = vim.g
    g.nightflyCursorColor = true
    g.nightflyItalics = true
    g.nightflyNormalFloat = false
    g.nightflyTerminalColors = true
    g.nightflyTransparent = false
    g.nightflyUndercurls = true
    g.nightflyUnderlineMatchParen = false
    g.nightflyWinSeparator = 0
    g.nightflyVirtualTextColor = true
  end
}

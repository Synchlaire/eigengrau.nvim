-- Plain colorscheme - Auto variant (follows vim.o.background)
-- Minimalist, distraction-free colors for focused editing

local M = {}

-- Palettes
M.palettes = {
  dark = {
    bg = "#121212",
    bg_alt = "#1a1a1a",
    fg = "#b0b0b0",
    fg_dim = "#707070",
    fg_bright = "#d0d0d0",
    accent = "#87afd7",
    accent_dim = "#5f87af",
    string = "#afaf87",
    error = "#d78787",
    warn = "#d7af87",
    info = "#87afd7",
    hint = "#87af87",
    add = "#87af87",
    change = "#d7af87",
    delete = "#d78787",
    selection = "#303030",
    comment = "#606060",
    border = "#404040",
  },
  light = {
    bg = "#f5f5f5",
    bg_alt = "#e8e8e8",
    fg = "#444444",
    fg_dim = "#888888",
    fg_bright = "#222222",
    accent = "#0087af",
    accent_dim = "#005f87",
    string = "#5f5f00",
    error = "#af0000",
    warn = "#875f00",
    info = "#005faf",
    hint = "#005f00",
    add = "#005f00",
    change = "#875f00",
    delete = "#af0000",
    selection = "#d7d7d7",
    comment = "#808080",
    border = "#c0c0c0",
  },
}

-- Apply the colorscheme
M.setup = function(variant)
  local palette

  if variant == "auto" or variant == nil then
    palette = vim.o.background == "dark" and M.palettes.dark or M.palettes.light
  elseif variant == "dark" then
    palette = M.palettes.dark
  elseif variant == "light" then
    palette = M.palettes.light
  else
    palette = M.palettes.dark
  end

  local p = palette
  local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  -- Clear existing highlights
  vim.cmd("highlight clear")
  if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
  end

  vim.g.colors_name = "plain"
  vim.o.termguicolors = true

  -- Editor UI
  hi("Normal", { fg = p.fg, bg = p.bg })
  hi("NormalNC", { fg = p.fg_dim, bg = p.bg })
  hi("NormalFloat", { fg = p.fg, bg = p.bg_alt })
  hi("FloatBorder", { fg = p.border, bg = p.bg_alt })
  hi("FloatTitle", { fg = p.accent, bg = p.bg_alt, bold = true })

  hi("Cursor", { fg = p.bg, bg = p.fg })
  hi("CursorLine", { bg = p.bg_alt })
  hi("CursorLineNr", { fg = p.fg_bright, bold = true })
  hi("LineNr", { fg = p.fg_dim })
  hi("SignColumn", { bg = p.bg })
  hi("FoldColumn", { fg = p.fg_dim, bg = p.bg })
  hi("Folded", { fg = p.comment, bg = p.bg_alt })

  hi("StatusLine", { fg = p.fg, bg = p.bg_alt })
  hi("StatusLineNC", { fg = p.fg_dim, bg = p.bg_alt })
  hi("TabLine", { fg = p.fg_dim, bg = p.bg_alt })
  hi("TabLineFill", { bg = p.bg_alt })
  hi("TabLineSel", { fg = p.fg_bright, bg = p.bg, bold = true })
  hi("WinSeparator", { fg = p.border })
  hi("VertSplit", { fg = p.border })

  hi("Pmenu", { fg = p.fg, bg = p.bg_alt })
  hi("PmenuSel", { fg = p.fg_bright, bg = p.selection })
  hi("PmenuSbar", { bg = p.bg_alt })
  hi("PmenuThumb", { bg = p.border })

  hi("Visual", { bg = p.selection })
  hi("VisualNOS", { bg = p.selection })
  hi("Search", { fg = p.bg, bg = p.accent })
  hi("IncSearch", { fg = p.bg, bg = p.accent, bold = true })
  hi("CurSearch", { fg = p.bg, bg = p.accent, bold = true })
  hi("Substitute", { fg = p.bg, bg = p.warn })

  hi("MatchParen", { fg = p.accent, bold = true, underline = true })
  hi("NonText", { fg = p.fg_dim })
  hi("SpecialKey", { fg = p.fg_dim })
  hi("Whitespace", { fg = p.fg_dim })
  hi("EndOfBuffer", { fg = p.bg })

  hi("Directory", { fg = p.accent })
  hi("Title", { fg = p.fg_bright, bold = true })
  hi("ErrorMsg", { fg = p.error, bold = true })
  hi("WarningMsg", { fg = p.warn, bold = true })
  hi("MoreMsg", { fg = p.info })
  hi("ModeMsg", { fg = p.fg_bright, bold = true })
  hi("Question", { fg = p.info })

  hi("DiffAdd", { fg = p.add, bg = p.bg_alt })
  hi("DiffChange", { fg = p.change, bg = p.bg_alt })
  hi("DiffDelete", { fg = p.delete, bg = p.bg_alt })
  hi("DiffText", { fg = p.warn, bg = p.bg_alt, bold = true })

  hi("SpellBad", { undercurl = true, sp = p.error })
  hi("SpellCap", { undercurl = true, sp = p.warn })
  hi("SpellLocal", { undercurl = true, sp = p.info })
  hi("SpellRare", { undercurl = true, sp = p.hint })

  -- Syntax (minimal differentiation - that's the point)
  hi("Comment", { fg = p.comment, italic = true })
  hi("Constant", { fg = p.fg })
  hi("String", { fg = p.string })
  hi("Character", { fg = p.string })
  hi("Number", { fg = p.fg })
  hi("Boolean", { fg = p.fg, bold = true })
  hi("Float", { fg = p.fg })

  hi("Identifier", { fg = p.fg })
  hi("Function", { fg = p.fg_bright })

  hi("Statement", { fg = p.fg_bright })
  hi("Conditional", { fg = p.fg_bright })
  hi("Repeat", { fg = p.fg_bright })
  hi("Label", { fg = p.fg_bright })
  hi("Operator", { fg = p.fg })
  hi("Keyword", { fg = p.fg_bright, bold = true })
  hi("Exception", { fg = p.fg_bright })

  hi("PreProc", { fg = p.fg_dim })
  hi("Include", { fg = p.fg_dim })
  hi("Define", { fg = p.fg_dim })
  hi("Macro", { fg = p.fg_dim })
  hi("PreCondit", { fg = p.fg_dim })

  hi("Type", { fg = p.fg })
  hi("StorageClass", { fg = p.fg })
  hi("Structure", { fg = p.fg })
  hi("Typedef", { fg = p.fg })

  hi("Special", { fg = p.fg })
  hi("SpecialChar", { fg = p.string })
  hi("Tag", { fg = p.accent })
  hi("Delimiter", { fg = p.fg })
  hi("SpecialComment", { fg = p.comment, bold = true })
  hi("Debug", { fg = p.warn })

  hi("Underlined", { underline = true })
  hi("Ignore", { fg = p.fg_dim })
  hi("Error", { fg = p.error, bold = true })
  hi("Todo", { fg = p.warn, bold = true })

  -- Diagnostics
  hi("DiagnosticError", { fg = p.error })
  hi("DiagnosticWarn", { fg = p.warn })
  hi("DiagnosticInfo", { fg = p.info })
  hi("DiagnosticHint", { fg = p.hint })
  hi("DiagnosticOk", { fg = p.add })

  hi("DiagnosticUnderlineError", { undercurl = true, sp = p.error })
  hi("DiagnosticUnderlineWarn", { undercurl = true, sp = p.warn })
  hi("DiagnosticUnderlineInfo", { undercurl = true, sp = p.info })
  hi("DiagnosticUnderlineHint", { undercurl = true, sp = p.hint })

  hi("DiagnosticVirtualTextError", { fg = p.error, italic = true })
  hi("DiagnosticVirtualTextWarn", { fg = p.warn, italic = true })
  hi("DiagnosticVirtualTextInfo", { fg = p.info, italic = true })
  hi("DiagnosticVirtualTextHint", { fg = p.hint, italic = true })

  -- LSP
  hi("LspReferenceText", { bg = p.selection })
  hi("LspReferenceRead", { bg = p.selection })
  hi("LspReferenceWrite", { bg = p.selection })
  hi("LspSignatureActiveParameter", { fg = p.accent, bold = true })

  -- Treesitter
  hi("@comment", { link = "Comment" })
  hi("@punctuation", { fg = p.fg_dim })
  hi("@constant", { link = "Constant" })
  hi("@constant.builtin", { fg = p.fg, bold = true })
  hi("@string", { link = "String" })
  hi("@character", { link = "Character" })
  hi("@number", { link = "Number" })
  hi("@boolean", { link = "Boolean" })
  hi("@float", { link = "Float" })
  hi("@function", { link = "Function" })
  hi("@function.builtin", { fg = p.fg_bright })
  hi("@parameter", { fg = p.fg })
  hi("@keyword", { link = "Keyword" })
  hi("@keyword.return", { fg = p.fg_bright, bold = true })
  hi("@conditional", { link = "Conditional" })
  hi("@repeat", { link = "Repeat" })
  hi("@label", { link = "Label" })
  hi("@operator", { link = "Operator" })
  hi("@exception", { link = "Exception" })
  hi("@type", { link = "Type" })
  hi("@type.builtin", { fg = p.fg })
  hi("@namespace", { fg = p.fg_dim })
  hi("@variable", { fg = p.fg })
  hi("@variable.builtin", { fg = p.fg, italic = true })
  hi("@text", { fg = p.fg })
  hi("@text.strong", { bold = true })
  hi("@text.emphasis", { italic = true })
  hi("@text.underline", { underline = true })
  hi("@text.title", { fg = p.fg_bright, bold = true })
  hi("@text.uri", { fg = p.accent, underline = true })
  hi("@tag", { fg = p.fg_bright })
  hi("@tag.attribute", { fg = p.fg })
  hi("@tag.delimiter", { fg = p.fg_dim })

  -- Markdown
  hi("markdownHeadingDelimiter", { fg = p.accent, bold = true })
  hi("markdownH1", { fg = p.fg_bright, bold = true })
  hi("markdownH2", { fg = p.fg_bright, bold = true })
  hi("markdownH3", { fg = p.fg_bright, bold = true })
  hi("markdownH4", { fg = p.fg_bright })
  hi("markdownH5", { fg = p.fg_bright })
  hi("markdownH6", { fg = p.fg_bright })
  hi("markdownBold", { bold = true })
  hi("markdownItalic", { italic = true })
  hi("markdownCode", { fg = p.string, bg = p.bg_alt })
  hi("markdownCodeBlock", { fg = p.string })
  hi("markdownLinkText", { fg = p.accent, underline = true })
  hi("markdownUrl", { fg = p.fg_dim, underline = true })

  -- Git
  hi("GitSignsAdd", { fg = p.add })
  hi("GitSignsChange", { fg = p.change })
  hi("GitSignsDelete", { fg = p.delete })

  -- Telescope
  hi("TelescopeNormal", { fg = p.fg, bg = p.bg })
  hi("TelescopeBorder", { fg = p.border, bg = p.bg })
  hi("TelescopePromptNormal", { fg = p.fg, bg = p.bg_alt })
  hi("TelescopePromptBorder", { fg = p.border, bg = p.bg_alt })
  hi("TelescopePromptTitle", { fg = p.accent, bg = p.bg_alt, bold = true })
  hi("TelescopePreviewTitle", { fg = p.accent, bold = true })
  hi("TelescopeResultsTitle", { fg = p.accent, bold = true })
  hi("TelescopeSelection", { bg = p.selection })
  hi("TelescopeMatching", { fg = p.accent, bold = true })

  -- WhichKey
  hi("WhichKey", { fg = p.accent })
  hi("WhichKeyGroup", { fg = p.fg_bright })
  hi("WhichKeyDesc", { fg = p.fg })
  hi("WhichKeySeperator", { fg = p.fg_dim })
  hi("WhichKeySeparator", { fg = p.fg_dim })
  hi("WhichKeyFloat", { bg = p.bg_alt })
  hi("WhichKeyValue", { fg = p.fg_dim })
end

-- Load the colorscheme
M.setup("auto")

return M

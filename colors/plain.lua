-- Plain colorscheme - Auto variant (follows vim.o.background)
-- Minimalist, distraction-free colors for focused editing

local M = {}

-- Palettes (adapted from vim-colors-plain by andreypopp)
M.palettes = {
  dark = {
    bg = "#000000",           -- s:black
    bg_alt = "#303030",       -- s:subtle_black
    fg = "#CCCCCC",           -- s:lighter_gray (norm)
    fg_dim = "#999999",       -- s:light_gray (norm_subtle)
    fg_bright = "#E5E5E5",    -- s:lightest_gray
    accent = "#B6D6FD",       -- s:light_blue (constant)
    accent_dim = "#008EC4",   -- s:dark_blue
    string = "#B6D6FD",       -- s:light_blue (constant in vim-colors-plain)
    error = "#E32791",        -- s:light_red
    warn = "#F3E430",         -- s:light_yellow
    info = "#4FB8CC",         -- s:light_cyan
    hint = "#5FD7A7",         -- s:light_green
    add = "#5FD7A7",          -- s:light_green
    change = "#F3E430",       -- s:light_yellow
    delete = "#E32791",       -- s:light_red
    selection = "#545454",    -- s:lighter_black (visual)
    comment = "#999999",      -- s:light_gray
    border = "#424242",       -- s:light_black
    purple = "#6855DE",       -- s:light_purple
    cyan = "#4FB8CC",         -- s:light_cyan
    cursor_line = "#303030",  -- s:subtle_black
  },
  light = {
    bg = "#F1F1F1",           -- s:white
    bg_alt = "#E5E5E5",       -- s:lightest_gray
    fg = "#424242",           -- s:light_black (norm)
    fg_dim = "#545454",       -- s:lighter_black (norm_subtle)
    fg_bright = "#222222",    -- s:black
    accent = "#008EC4",       -- s:dark_blue (constant)
    accent_dim = "#005f87",   -- darker variant
    string = "#008EC4",       -- s:dark_blue (constant in vim-colors-plain)
    error = "#C30771",        -- s:dark_red
    warn = "#A89C14",         -- s:dark_yellow
    info = "#20A5BA",         -- s:dark_cyan
    hint = "#10A778",         -- s:dark_green
    add = "#10A778",          -- s:dark_green
    change = "#A89C14",       -- s:dark_yellow
    delete = "#C30771",       -- s:dark_red
    selection = "#B6D6FD",    -- s:light_blue (visual)
    comment = "#999999",      -- s:light_gray
    border = "#CCCCCC",       -- s:lighter_gray
    purple = "#523C79",       -- s:dark_purple
    cyan = "#20A5BA",         -- s:dark_cyan
    cursor_line = "#E5E5E5",  -- s:lightest_gray
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
  hi("CursorLine", { bg = p.cursor_line })
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

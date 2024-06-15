-- Save this file as 'ashes.lua' in your nvim colors folder
-- Usually located at ~/.config/nvim/colors/

local ashes = {}

ashes.colors = {
  background = "#EDEAEA",
  foreground = "#393B3F",
  cursor = "#808790",
  color0 = "#EDEAEA",
  color1 = "#393B3F",
  color2 = "#808790",
  color3 = "#A3A3A4",
  color4 = "#000000",
  color5 = "#333333",
  color6 = "#777777",
  color7 = "#DDDDDD",
  color8 = "#ffffff"
}

function ashes.setup()
  vim.cmd("highlight clear")
  vim.cmd("syntax reset")
  vim.o.background = "light"
  vim.g.colors_name = "ashes"

  local highlights = {
    Normal = { fg = ashes.colors.foreground, bg = ashes.colors.background },
    Cursor = { fg = ashes.colors.cursor, bg = ashes.colors.background },
    LineNr = { fg = ashes.colors.color6 },
    Comment = { fg = ashes.colors.color3, italic = true },
    Constant = { fg = ashes.colors.color4 },
    Identifier = { fg = ashes.colors.color2 },
    Statement = { fg = ashes.colors.color1 },
    PreProc = { fg = ashes.colors.color2 },
    Type = { fg = ashes.colors.color5 },
    Special = { fg = ashes.colors.color3 },
    Underlined = { fg = ashes.colors.color4, underline = true },
    Todo = { fg = ashes.colors.color7, bg = ashes.colors.color1 },
    Error = { fg = ashes.colors.color8, bg = ashes.colors.color1 },
    Visual = { bg = ashes.colors.color7 }
  }

  for group, opts in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, opts)
  end
end

return ashes

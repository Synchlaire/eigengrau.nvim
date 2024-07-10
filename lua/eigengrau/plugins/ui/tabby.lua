return {
  'nanozuki/tabby.nvim',
  event = "TabNew",
  config = function()
    local util = require('tabby.util')
    local hl_tabline_fill = 'nil' -- Background
    local hl_tabline = 'nil' --background
    local hl_tabline_sel = util.extract_nvim_hl('TabLineSel')  -- Highlight
    local hl_tabline_bubble = util.extract_nvim_hl('lualine_a_normal')  -- Highlight

    local function tab_label_active(tabid, active)
      local icon = active and ' ' or ' '
      local number = vim.api.nvim_tabpage_get_number(tabid)
      local name = util.get_tab_name(tabid)
      return string.format(' %s %s ', icon, name)
    end
   local function tab_label_inactive(tabid, active)
      local icon = active and ' ' or ' '
      local name = util.get_tab_name(tabid)
      return string.format(' %s %s', icon, name)
    end


    -- theme
    local the_theme = {
      head = {
        { '  ', hl = { fg = hl_tabline.fg, bg = hl_tabline.bg } },
        { '', hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg } },
      },
      active_tab = {
        label = function(tabid)
          return {
            tab_label_active(tabid, true),
            hl = { fg = hl_tabline_sel.fg, bg = hl_tabline_sel.bg, style='bold' },
          }
        end,
--        left_sep = { '', hl = { fg = hl_tabline_sel.fg, bg = hl_tabline_sel.bg } },
--       right_sep = { '', hl = { fg = hl_tabline_sel.fg, bg = hl_tabline_sel.bg } },
      },
      inactive_tab = {
        label = function(tabid)
          return {
            tab_label_inactive(tabid, false),
            hl = { fg = hl_tabline.fg, bg = 'nil', style='italic' },
          }
        end,
        left_sep = { ' ', hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg } },
        right_sep = { ' ', hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg } },
      },
    }

    require('tabby').setup({
      tabline = the_theme,
      buf_name = {
      mode = "'unique'",
    }

    })
  end
}

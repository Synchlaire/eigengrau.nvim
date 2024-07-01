return {
  'alvarosevilla95/luatab.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
 event = { "TabNew", "TabEnter", "TabNewEntered" },

  config = function()
local status, luatab = pcall(require, 'luatab')
if (not status) then return end
    require'luatab'.setup {
      windowCount = function(idx) return idx .. " " end,
      modified = function() return "" end,
      separator = function(idx)
        local s = require('eigengrau.components.icons').separators.vertical_bar_thin
        return (idx < vim.fn.tabpagenr('$') and '%#TabLine#' .. s or '')
      end
    }
  end

}


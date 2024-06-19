return {
'xiyaowong/transparent.nvim',
    event = "VeryLazy",
   config = function()
require("transparent").setup({ -- Optional, you don't have to run setup.
  groups = { -- table: default groups
    'Normal', 'Comment', 'Constant', 'Special', 'Identifier',
    'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
    'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
    'SignColumn', 'CursorLine', 'CursorLineNr', 'EndOfBuffer'
  },
  extra_groups = {"NormalFloat"}, -- table: additional groups that should be cleared
  exclude_groups = {}, -- table: groups you don't want to clear
})

    end

}

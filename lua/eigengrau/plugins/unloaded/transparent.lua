return {
'xiyaowong/transparent.nvim',
    event = "VeryLazy",
   config = function()
require('transparent').clear_prefix('lualine')
require("transparent").setup({ -- Optional, you don't have to run setup.
  groups = {},

  extra_groups = {"NormalFloat"}, -- table: additional groups that should be cleared
  exclude_groups = {}, -- table: groups you don't want to clear
})

    end

}


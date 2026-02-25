return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  config = function()
    require('which-key').setup({
      preset = 'modern', -- classic, modern, helix
      delay = function(ctx)
        return ctx.plugin and 0 or 120
      end,
      filter = function()
        return true
      end,
      spec = {
        { '<leader>b',     group = 'Buffers' },
        { '<leader>c',     group = 'Code' },
        { '<leader>d',     group = 'Delete' },
        { '<leader>f',     group = 'Find' },
        { '<leader>g',     group = 'Git' },
        { '<leader>h',     group = 'Home' },
        { '<leader>i',     group = 'AI', mode = { 'n', 'v' } },
        { '<leader>iv',    desc = 'Visual AI', mode = 'v' },
        { '<leader>is',    desc = '99 Search' },
        { '<leader>ix',    desc = 'Stop All' },
        { '<leader>il',    desc = 'View Logs' },
        { '<leader>l',     group = 'LSP/Lazy' },
        { '<leader>m',     group = 'Mason' },
        { '<leader>o',     group = 'Obsidian' },
        { '<leader>Q',     group = 'Quit' },
        { '<leader>r',     group = 'Run/Rename' },
        { '<leader>s',     group = 'Split/Session' },
        { '<leader>t',     group = 'Toggle' },
        { '<leader>u',     group = 'UI' },
        { '<leader>w',     group = 'Window' },
        { '<leader>x',     group = 'Execute' },
        { '<leader><Tab>', group = 'Tabs' },
      },
      notify = false,
      triggers = {
        { '<auto>', mode = 'nixsotc' },
      },
      defer = function(ctx)
        return ctx.mode == 'V' or ctx.mode == '<C-V>'
      end,
      plugins = {
        marks = true,
        registers = true,
        spelling = {
          enabled = true,
          suggestions = 20,
        },
        presets = {
          operators = true,
          motions = true,
          text_objects = true,
          windows = true,
          nav = true,
          z = true,
          g = true,
        },
      },
      win = {
        border = 'single',
        no_overlap = true,
        padding = { 1, 2 },
        title = true,
        title_pos = 'center',
        zindex = 1000,
        bo = {},
        wo = {},
      },
      layout = {
        width = { min = 24, max = 52 },
        spacing = 2,
      },
      keys = {
        scroll_down = '<c-d>',
        scroll_up = '<c-u>',
      },
      sort = { 'local', 'order', 'group', 'alphanum', 'mod' },
      expand = 0,
      replace = {
        key = {
          function(key)
            return require('which-key.view').format(key)
          end,
        },
        desc = {
          { '<Plug>%(?(.*)%)?', '%1' },
          { '^%+',              '' },
          { '<[cC]md>',         '' },
          { '<[cC][rR]>',       '' },
          { '<[sS]ilent>',      '' },
          { '^lua%s+',          '' },
          { '^call%s+',         '' },
          { '^:%s*',            '' },
        },
      },
      icons = {
        breadcrumb = '>',
        separator = '>',
        group = '+',
        ellipsis = '...',
        rules = {},
        colors = false,
      },
      show_help = true,
      show_keys = true,
      disable = {
        ft = {},
        bt = {},
      },
      debug = false,
    })
  end,
}

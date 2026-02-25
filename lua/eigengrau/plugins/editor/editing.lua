-- Editing enhancement plugins
return {
  -- Surround text objects
  {
    "kylechui/nvim-surround",
    event = "BufReadPost",
    init = function()
      vim.g.nvim_surround_no_mappings = false
    end,
    keys = {
      { "<C-s>",  "<Plug>(nvim-surround-insert)",          mode = "i", desc = "Surround insert" },
      { "<C-g>S", "<Plug>(nvim-surround-insert-line)",     mode = "i", desc = "Surround insert line" },
      { "ys",     "<Plug>(nvim-surround-normal)",          mode = "n", desc = "Surround motion" },
      { "ys.",    "<Plug>(nvim-surround-normal-cur)",      mode = "n", desc = "Surround current line" },
      { "yS",     "<Plug>(nvim-surround-normal-line)",     mode = "n", desc = "Surround motion line" },
      { "ySS",    "<Plug>(nvim-surround-normal-cur-line)", mode = "n", desc = "Surround current line block" },
      { "s",      "<Plug>(nvim-surround-visual)",          mode = "x", desc = "Surround visual selection" },
      { "gS",     "<Plug>(nvim-surround-visual-line)",     mode = "x", desc = "Surround visual selection line" },
      { "ds",     "<Plug>(nvim-surround-delete)",          mode = "n", desc = "Delete surround" },
      { "cs",     "<Plug>(nvim-surround-change)",          mode = "n", desc = "Change surround" },
      { "cS",     "<Plug>(nvim-surround-change-line)",     mode = "n", desc = "Change surround line" },
    },
    opts = {
      aliases = {
        ["a"] = ">",
        ["p"] = ")",
        ["c"] = "}",
        ["b"] = "]",
        ["q"] = { '"', "'", "`" },
        ["s"] = { "}", "]", ")", ">", '"', "'", "`" },
      },
      highlight = {
        duration = 2,
      },
      move_cursor = "begin",
    },
  },

  -- Comments
  {
    "numToStr/comment.nvim",
    event = "BufReadPost",
    opts = {
      padding = true,
      sticky = true,
      ignore = nil,
      toggler = {
        line = "gcc",
        block = "gbc",
      },
      opleader = {
        line = "gc",
        block = "gb",
      },
      extra = {
        above = "gcO",
        below = "gco",
        eol = "gcA",
      },
      mappings = {
        basic = true,
        extra = true,
      },
      pre_hook = nil,
      post_hook = nil,
    },
  },

  -- Enhanced increment/decrement
  {
    "monaqa/dial.nvim",
    keys = {
      { "<C-a>", function() return require("dial.map").inc_normal() end, expr = true, desc = "Increment" },
      { "<C-x>", function() return require("dial.map").dec_normal() end, expr = true, desc = "Decrement" },
    },
    config = function()
      local augend = require("dial.augend")
      require("dial.config").augends:register_group({
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias["%Y/%m/%d"],
          augend.constant.alias.bool,
          augend.semver.alias.semver,
          augend.constant.new({ elements = { "let", "const" } }),
          augend.constant.new({
            elements = { "before", "after" },
            word = true,
            cyclic = true,
          }),
          augend.constant.new({
            elements = { "correcto", "incorrecto" },
            word = true,
            cyclic = true,
          }),
        },
      })
    end,
  },

  -- Tab out of pairs
  {
    "kawre/neotab.nvim",
    event = "InsertEnter",
    opts = {
      {
        tabkey = "<Tab>",
        act_as_tab = true,
        behavior = "nested",
        pairs = {
          { open = "(", close = ")" },
          { open = "[", close = "]" },
          { open = "{", close = "}" },
          { open = "'", close = "'" },
          { open = '"', close = '"' },
          { open = "`", close = "`" },
          { open = "<", close = ">" },
        },
        exclude = {},
        smart_punctuators = {
          enabled = true,
          semicolon = {
            enabled = true,
            ft = { "cs", "c", "cpp", "java" },
          },
          escape = {
            enabled = true,
            triggers = {},
          },
        },
      },
    },
  },
}

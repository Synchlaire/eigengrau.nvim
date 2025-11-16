-- Editing enhancement plugins
return {
  -- Surround text objects
  {
    "kylechui/nvim-surround",
    event = "BufReadPost",
    opts = {
      keymaps = {
        insert = "<C-s>",
        normal = "ys",
        normal_cur = "ys.",
        visual = "s",
        visual_line = "gS",
        delete = "ds",
        change = "cs",
        change_line = "cS",
      },
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
            enabled = false,
            ft = { "cs", "c", "cpp", "java" },
          },
          escape = {
            enabled = false,
            triggers = {},
          },
        },
      },
    },
  },
}

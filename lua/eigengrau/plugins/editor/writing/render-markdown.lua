return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = "markdown",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  opts = {
    file_types = { "markdown" },
    render_modes = { "n", "c" }, -- Not in insert/visual
    anti_conceal = {
      enabled = true, -- Show raw markdown on cursor line
    },
    heading = {
      enabled = true,
      icons = {}, -- No ### icons in text
      sign = true, -- Enable gutter icons
      signs = { "󰎤 ", "󰎧 ", "󰎪 ", "󰎭 ", "󰎰 ", "󰎳 " }, -- Gutter icons for H1-H6
      width = "block", -- Partial background (just heading text, not full line)
      -- Background highlight groups
      backgrounds = {
        "RenderMarkdownH1Bg",
        "RenderMarkdownH2Bg",
        "RenderMarkdownH3Bg",
        "RenderMarkdownH4Bg",
        "RenderMarkdownH5Bg",
        "RenderMarkdownH6Bg",
      },
      -- Foreground (text color) - links to theme's accent colors
      foregrounds = {
        "RenderMarkdownH1",
        "RenderMarkdownH2",
        "RenderMarkdownH3",
        "RenderMarkdownH4",
        "RenderMarkdownH5",
        "RenderMarkdownH6",
      },
    },
    code = {
      enabled = true,
      style = "language",
      position = "right",
      language_pad = 2,
      disable_background = { "diff" },
      width = "block",
      border = "thin",
    },
    bullet = {
      enabled = true,
      icons = { "•", "◦", "▪", "▫" },
    },
    checkbox = {
      enabled = true,
      position = "inline", -- Don't replace, render inline to avoid eating characters
      unchecked = {
        icon = "☐ ",
        highlight = "RenderMarkdownUnchecked",
      },
      checked = {
        icon = "☑ ",
        highlight = "RenderMarkdownChecked",
      },
    },
    quote = {
      enabled = true,
      icon = "▎",
    },
    pipe_table = {
      enabled = true,
      style = "normal",
      cell = "padded",
      border = {
        "┌", "┬", "┐",
        "├", "┼", "┤",
        "└", "┴", "┘",
        "│", "─",
      },
    },
    link = {
      enabled = true, -- Enable to conceal brackets
      image = "󰥶 ",
      hyperlink = "", -- No icon for links
      highlight = "RenderMarkdownLink",
    },
    win_options = {
      conceallevel = { default = 1, rendered = 3 }, -- 3 = completely hide concealed text (brackets)
      concealcursor = { default = "", rendered = "nc" }, -- Conceal in normal/command mode
    },
    debounce = 100,
    max_file_size = 10.0, -- MB limit
  },
  config = function(_, opts)
    require("render-markdown").setup(opts)

    -- Link heading colors to your theme's accent colors (adapts automatically)
    -- Using common highlight group names that most colorschemes define
    vim.api.nvim_set_hl(0, "RenderMarkdownH1", { link = "Title", bold = true })
    vim.api.nvim_set_hl(0, "RenderMarkdownH2", { link = "Function", bold = true })
    vim.api.nvim_set_hl(0, "RenderMarkdownH3", { link = "String" })
    vim.api.nvim_set_hl(0, "RenderMarkdownH4", { link = "Identifier" })
    vim.api.nvim_set_hl(0, "RenderMarkdownH5", { link = "Type" })
    vim.api.nvim_set_hl(0, "RenderMarkdownH6", { link = "Comment", italic = true })

    -- Subtle background tints (very dark, barely visible)
    vim.api.nvim_set_hl(0, "RenderMarkdownH1Bg", { bg = "#252535" })
    vim.api.nvim_set_hl(0, "RenderMarkdownH2Bg", { bg = "#252530" })
    vim.api.nvim_set_hl(0, "RenderMarkdownH3Bg", { bg = "#252528" })
    vim.api.nvim_set_hl(0, "RenderMarkdownH4Bg", { bg = "#252525" })
    vim.api.nvim_set_hl(0, "RenderMarkdownH5Bg", { bg = "#252525" })
    vim.api.nvim_set_hl(0, "RenderMarkdownH6Bg", { bg = "#252525" })

    -- Checkbox highlights
    vim.api.nvim_set_hl(0, "RenderMarkdownUnchecked", { fg = "#6C7086" })
    vim.api.nvim_set_hl(0, "RenderMarkdownChecked", { fg = "#A6E3A1", bold = true })

    -- Link highlight (underline only, no icon)
    vim.api.nvim_set_hl(0, "RenderMarkdownLink", { link = "Underlined" })
  end,
  keys = {
    { "<leader>tm", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle markdown rendering" },
  },
}

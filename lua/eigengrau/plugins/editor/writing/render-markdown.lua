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

    -- Get theme colors for headings
    local function get_hl_color(group, attr)
      local hl = vim.api.nvim_get_hl(0, { name = group })
      return hl[attr] and string.format("#%06x", hl[attr]) or nil
    end

    -- Set foreground colors (link to theme)
    vim.api.nvim_set_hl(0, "RenderMarkdownH1", { link = "Title", bold = true })
    vim.api.nvim_set_hl(0, "RenderMarkdownH2", { link = "Function", bold = true })
    vim.api.nvim_set_hl(0, "RenderMarkdownH3", { link = "String" })
    vim.api.nvim_set_hl(0, "RenderMarkdownH4", { link = "Identifier" })
    vim.api.nvim_set_hl(0, "RenderMarkdownH5", { link = "Type" })
    vim.api.nvim_set_hl(0, "RenderMarkdownH6", { link = "Comment", italic = true })

    -- Set backgrounds with inherited foreground colors (so text shows through)
    vim.api.nvim_set_hl(0, "RenderMarkdownH1Bg", {
      fg = get_hl_color("Title", "fg"),
      bg = "#1a1a2e",
      bold = true,
    })
    vim.api.nvim_set_hl(0, "RenderMarkdownH2Bg", {
      fg = get_hl_color("Function", "fg"),
      bg = "#1a1a28",
      bold = true,
    })
    vim.api.nvim_set_hl(0, "RenderMarkdownH3Bg", {
      fg = get_hl_color("String", "fg"),
      bg = "#1a1a24",
    })
    vim.api.nvim_set_hl(0, "RenderMarkdownH4Bg", {
      fg = get_hl_color("Identifier", "fg"),
      bg = "#1a1a20",
    })
    vim.api.nvim_set_hl(0, "RenderMarkdownH5Bg", {
      fg = get_hl_color("Type", "fg"),
      bg = "#1a1a1e",
    })
    vim.api.nvim_set_hl(0, "RenderMarkdownH6Bg", {
      fg = get_hl_color("Comment", "fg"),
      bg = "#1a1a1c",
      italic = true,
    })

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

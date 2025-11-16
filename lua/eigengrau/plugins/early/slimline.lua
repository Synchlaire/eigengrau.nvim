-- Custom progress bar component
local custom_progress = function()
  local ok, result = pcall(function()
    local line = vim.fn.line(".")
    local total = vim.fn.line("$")
    local percent = 0
    if total > 1 then
      -- Use (line - 1) / (total - 1) to make it start from 0
      percent = ((line - 1) / (total - 1)) * 100
    elseif total == 1 then
      -- If there's only one line, or buffer is empty but line is 1, it's 100%
      percent = 100
    end

    -- Clamp percentage between 0 and 100
    percent = math.max(0, math.min(100, percent))

    local width = 10
    local filled_len = math.floor((percent / 100) * width)
    local empty_len = width - filled_len

    -- local bar = string.rep("❘", filled_len) .. string.rep(" ", empty_len)
    local bar = string.rep("ǀ", filled_len) .. string.rep(" ", empty_len)

    -- Format percentage to two decimal places, without the '%' sign
    local percent_str = string.format("%.2f", percent)

    return "%#Normal#" .. bar .. " " .. percent_str
  end)

  if ok then
    return result
  else
    return "ERROR"
  end
end

-- Line number component
local line_info = function()
  local line = vim.fn.line(".")
  local total = vim.fn.line("$")
  return string.format("[%d/%d]", line, total)
end

return {
  "sschleemilch/slimline.nvim",
  lazy = false,
  --  cond = not vim.g.neovide,
  opts = {
    bold = true,
    style = "fg",

    components = {
      left = {
        "recording",
        "mode",
        "path",
        custom_progress,
        line_info,
      },
      center = {
      },
      right = {
        "diagnostics",
        "filetype_lsp",
        "git",
      },
    },

    configs = {
      mode = {
        verbose = false,
        hl = {
          normal = "Type",
          insert = "Function",
          pending = "Boolean",
          visual = "Keyword",
          command = "String",
        },
      },

      path = {
        directory = true,
        icons = {
          folder = " ",
          modified = "*",
          read_only = "",
        },
      },

      git = {
        icons = {
          branch = "",
          added = "+",
          modified = "~",
          removed = "-",
        },
      },

      diagnostics = {
        workspace = true,
        icons = {
          error = "",
          warn = "",
          hint = "",
          info = "",
        },
      },

      filetype_lsp = {},

      recording = {
        icon = "  ",
      },

    },

    spaces = {
      components = " ",
      left = " ",
      right = " ",
    },

    sep = {
      hide = {
        first = true,
        last = true,
      },
      left = "",
      right = "",
    },

    hl = {
      base = "Comment",
      primary = "Normal",
      secondary = "Comment",
    },
  },
}

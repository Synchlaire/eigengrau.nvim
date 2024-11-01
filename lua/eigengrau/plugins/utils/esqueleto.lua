return {
  'cvigilv/esqueleto.nvim',
  lazy = true,
  cmd = "EsqueletoInsert",
  opts = {
  -- Standard options
  directories = { vim.fn.stdpath("config") .. "/skeletons" }, -- template directories
  patterns = vim.fn.readdir(vim.fn.stdpath("config") .. "/skeletons"),
  autouse = false, -- whether to auto-use a template if it's the only one for a pattern

  -- Wild-card options
  wildcards = {
    expand = true, -- whether to expand wild-cards
    lookup = { -- wild-cards look-up table
      -- File-specific
      ["filename"] = function() return vim.fn.expand("%:t:r") end,
      ["fileabspath"] = function() return vim.fn.expand("%:p") end,
      ["filerelpath"] = function() return vim.fn.expand("%:p:~") end,
      ["fileext"] = function() return vim.fn.expand("%:e") end,
      ["filetype"] = function() return vim.bo.filetype end,

      -- Datetime-specific
      ["date"] = function() return os.date("%d-%m-%Y", os.time()) end,
      ["year"] = function() return os.date("%Y", os.time()) end,
      ["month"] = function() return os.date("%m", os.time()) end,
      ["day"] = function() return os.date("%d", os.time()) end,
      ["time"] = function() return os.date("%T", os.time()) end,

    },
  },

  -- Advanced options
  advanced = {
    ignored = {}, -- List of glob patterns or function that determines if a file is ignored
    ignore_os_files = true, -- whether to ignore OS files (e.g. .DS_Store)
  }
  },
}


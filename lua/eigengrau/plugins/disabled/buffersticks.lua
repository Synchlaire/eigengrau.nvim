return {
  "ahkohd/buffer-sticks.nvim",
  lazy = true,
  event = "BufReadPost",
  keys = {
    {
      "<leader>a",
      function()
        BufferSticks.jump()
      end,
      desc = "Buffer jump mode",
    },
  },
  config = function()
    local sticks = require("buffer-sticks")
    sticks.setup({

      -- offset = { x = 0, y = 0 },    -- Position offset (positive moves inward from right edge)
      -- padding = { top = 0, right = 1, bottom = 0, left = 1 }, -- Padding inside the float
      -- active_char = "──",           -- Character for active buffer
      -- inactive_char = " ─",         -- Character for inactive buffers
      auto_hide = true,                -- Auto-hide when cursor is over float (default: true)
      -- label = { show = "jump" },       -- Label display: "always", "jump", or "never"
      jump = { show = { "filename", "space", "label" } }, -- Jump mode display options
      -- winblend = 100,                    -- Window blend level (0-100, 0=opaque, 100=fully blended)
      -- filter = {
      --   filetypes = { "help", "qf" },    -- Exclude by filetype (also: "NvimTree", "neo-tree", "Trouble")
      --   buftypes = { "terminal" },       -- Exclude by buftype (also: "help", "quickfix", "nofile")
      --   names = { ".*%.git/.*", "^/tmp/.*" },  -- Exclude buffers matching lua patterns
      -- },
      transparent = true,
      filter = { buftypes = { "terminal" } },
      highlights = {
        active = { link = "Statement" },
        inactive = { link = "Whitespace" },
        label = { link = "Comment" },
      },
    })
    sticks.show()
  end,
}

return  {
  "echasnovski/mini.notify",
  version = "*",
  lazy = false,
  enabled = true,
  opts = {
    lsp_progress = {
      -- oh god please stop annoying me
      enable = false,
    },
    window = {
      config = {
	anchor = "SE",
	col = vim.o.columns,
	row = vim.o.lines - 2,
	width = math.floor(vim.o.columns * 0.5),
	border = "single",
      },
      winblend = 10,
    },
  },
  config = function(_, opts)
    require("mini.notify").setup(opts)

    -- Wrap all vim.notify calls with mini.notify
    vim.notify = require("mini.notify").make_notify()
  end,
}


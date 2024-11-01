return {
  "vague2k/huez.nvim",
  lazy = true,
  event = "UIEnter",
--  import = "huez-manager.import",
  branch = "stable",
  config = function()
    require("huez").setup ({
      path = vim.fs.normalize(vim.fn.stdpath("data") --[[@as string]]) .. "/huez",
      fallback = "neopywal",
      suppress_messages = true,
      theme_config_module = nil,
      exclude = {},
      picker = {
	themes = {
	  layout = "center",
	  opts = {},
	},
	favorites = {
	  layout = "center",
	  opts = {},
	},
	live = {
	  layout = "center",
	  opts = {},
	},
	ensured = {
	  layout = "center",
	  opts = {},
	},
      },
    })
  end,
}

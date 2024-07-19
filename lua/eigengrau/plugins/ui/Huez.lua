return {
  "vague2k/huez.nvim",
  dependencies = {
  "RedsXDD/neopywal.nvim",
  },
  import = "huez-manager.import",
  branch = "stable",
  event = "UIEnter",
  config = function()
    require("huez").setup ({
      path = vim.fs.normalize(vim.fn.stdpath("data") --[[@as string]]) .. "/huez",
      fallback = "neopywal",
      suppress_messages = true,
      theme_config_module = "plugins.test",
      exclude = {},
      picker = {
	themes = {
	  layout = "top",
	  opts = {},
	},
	favorites = {
	  layout = "top",
	  opts = {},
	},
	live = {
	  layout = "top",
	  opts = {},
	},
	ensured = {
	  layout = "top",
	  opts = {},
	},
      },
    })
  end,
}

-- Plain colorscheme
-- TODO: Once moved to separate repo, uncomment the url line and remove dir line
return {
  -- For external repo (uncomment when ready):
  -- url = "https://github.com/yourusername/plain-nvim",

  -- For local development (remove when using external repo):
  dir = vim.fn.stdpath("config"),
  name = "plain",
  lazy = false,
  priority = 1001,

  -- No config needed - colorscheme files in colors/ are automatically discovered
  -- Just use :colorscheme plain to activate
}

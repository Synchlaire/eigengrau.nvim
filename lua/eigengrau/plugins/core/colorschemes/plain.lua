-- Plain colorscheme - local plugin with auto theme detection
return {
  dir = "/home/claroscuro/projects/plain-nvim/vim-colors-plain",
  name = "plain",
  lazy = false,  -- Load at startup so colorschemes are always available
  priority = 1001,
  config = function()
    -- Initialize plain with auto theme detection
    require("plain").setup({
      theme = "auto",  -- auto-switch based on background option
      transparent = false,
      bold = true,
      italic = true,
      style = {
        comments = "italic",
        keywords = "bold",
      },
    })
  end,
}

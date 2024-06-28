return {
  'folke/zen-mode.nvim',
  dependencies = { 'folke/twilight.nvim' },
  cmd = { "ZenMode", "Twilight" },
  config = function()
    require("zen-mode").setup({
      window = {
	backdrop = 1, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
	-- height and width can be:
	-- * an absolute number of cells when > 1
	-- * a percentage of the width / height of the editor when <= 1
	-- * a function that returns the width or the height
	width = 0.65, -- width of the Zen window
	height = 1, -- height of the Zen window
	options = {
	  signcolumn = "yes",
	  number = false,
	  relativenumber = false,
	  cursorline = false,
	  cursorcolumn = false,
	  foldcolumn = "0",
	  fillchars = [[fold: ,foldopen:,foldsep: ,foldclose:]],
	  list = false,
	},
      },
      plugins = {
	-- disable some global vim options (vim.o...)
	-- comment the lines to not apply the options
	options = {
	  enabled = true,
	  ruler = false, -- disables the ruler text in the cmd line area
	  showcmd = false, -- disables the command in the last line of the screen
	  -- you may turn on/off statusline in zen mode by setting 'laststatus'
	  -- statusline will be shown only if 'laststatus' == 3
	  laststatus = 0, -- turn off the statusline in zen mode
	},
	twilight = { enabled = false }, -- enable to start Twilight when zen mode opens
	gitsigns = { enabled = false }, -- disables git signs

	-- this will change the font size on kitty when in zen mode
	-- to make this work, you need to set the following kitty options:
	-- - allow_remote_control socket-only
	-- - listen_on unix:/tmp/kitty
	kitty = {
	  enabled = true,
	  font = "+2", -- font size increment
	},
      },
      -- callback where you can add custom code when the Zen window opens
      on_open = function(win)
--	require("notify")("zen mode On") TODO: add a new notify method
	require("ibl").update{enabled = false}
      end,
      -- callback where you can add custom code when the Zen window closes
      on_close = function()
--	require("notify")("zen mode off")
	require("ibl").update{enabled = true}
      end,
    })
  end,

}

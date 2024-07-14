return {

  -- Cycle buffers with a customizable notification window
  {
    'ghillb/cybu.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      { '<A-,>', '<Plug>(CybuPrev)' },
      { '<A-.>', '<Plug>(CybuNext)' },
    },
    opts = {
      position = {
	anchor = "center",
	vertical_offset = 10,         -- vertical offset from anchor in lines
	horizontal_offset = 0,        -- vertical offset from anchor in columns
      },
      style = {
	path = "relative",
	border = "single",
	padding = "4",
	hide_buffer_id = "false",
	devicons = {
	  enabled = true,
	  colored = true,
	  truncate = true,
	},
	highlights = {
	  current_buffer = "lualine_a_insert",       -- current / selected buffer
	  adjacent_buffers = "CybuAdjacent",  -- buffers not in focus
	  background = "CybuBackground",      -- the window background
	  border = "CybuBorder",              -- border of the window
	},
	behavior = { -- set behavior for different modes
	  mode = {
	    default = {
	      switch = "on_close",     -- immediate, on_close
	      view = "rolling",         -- paging, rolling
	    },
	    last_used = {
	      switch = "on_close",      -- immediate, on_close
	      view = "rolling",          -- paging, rolling
	    },
	    auto = {
	      view = "paging", --paging, rolling
	    },
	  },
	  show_on_autocmd = true,      -- event to trigger cybu (eg. "BufEnter")
	}

      }



    },
  },
}

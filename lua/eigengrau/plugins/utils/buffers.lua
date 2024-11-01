return {
  "leath-dub/snipe.nvim",
  keys = {
    {"<leader>a", function () require("snipe").open_buffer_menu() end, desc = "Open Snipe buffer menu"}
  },
  opts = {
    ui = {
      max_width = -1, -- -1 means dynamic width
      -- Where to place the ui window
      -- Can be any of "topleft", "bottomleft", "topright", "bottomright", "center", "cursor" (sets under the current cursor pos)
      position = "cursor",
      -- Override options passed to `nvim_open_win`
      -- Be careful with this as snipe will not validate
      -- anything you override here. See `:h nvim_open_win`
      -- for config options
      open_win_override = {
	-- title = "My Window Title",
	border = "single", -- use "rounded" for rounded border
      },
    },
    hints = {
      -- Charaters to use for hints (NOTE: make sure they don't collide with the navigation keymaps)
      dictionary = "adflewcmpghio",
    },
    navigate = {
      -- When the list is too long it is split into pages
      -- `[next|prev]_page` options allow you to navigate
      -- this list
      next_page = "J",
      prev_page = "K",

      -- You can also just use normal navigation to go to the item you want
      -- this option just sets the keybind for selecting the item under the
      -- cursor
      under_cursor = "<cr>",

      -- In case you changed your mind, provide a keybind that lets you
      -- cancel the snipe and close the window.
      cancel_snipe = "q",

      -- Close the buffer under the cursor
      -- Remove "j" and "k" from your dictionary to navigate easier to delete
      -- NOTE: Make sure you don't use the character below on your dictionary
      close_buffer = "D",
    },
    -- The default sort used for the buffers
    -- Can be any of "last", (sort buffers by last accessed) "default" (sort buffers by its number)
    sort = "last"
  }


}

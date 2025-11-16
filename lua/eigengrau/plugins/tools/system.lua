-- System utilities - terminal and buffer management
return {
  -- Terminal management
  {
    "2kabhishek/termim.nvim",
    cmd = { "Fterm", "FTerm", "Sterm", "STerm", "Vterm", "VTerm" },
  },

  -- Buffer picker
  {
    "leath-dub/snipe.nvim",
    keys = {
      { "<leader>a", function() require("snipe").open_buffer_menu() end, desc = "Open buffer menu" },
    },
    opts = {
      ui = {
        max_width = -1,
        position = "center",
        open_win_override = {
          title = "Buffers",
          border = "rounded",
        },
        preselect_current = true,
        text_align = "file-first",
      },
      hints = {
        dictionary = "123456789",
      },
      navigate = {
        next_page = "J",
        prev_page = "K",
        under_cursor = "<cr>",
        cancel_snipe = "q",
        close_buffer = "d",
      },
      sort = "last",
    },
  },
}

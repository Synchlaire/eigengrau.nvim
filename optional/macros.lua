return {
  "ecthelionvi/NeoComposer.nvim",
  lazy = true,
  dependencies ={ "kkharji/sqlite.lua", lazy = true },
  event = { "RecordingEnter" },
  config = function()
    require("NeoComposer").setup({
      notify = true,
      --      delay_timer = 100,
      queue_most_recent = true,
      window = {
	width = 60,
	height = 10,
	border = "single",
	winhl = {
	  Normal = "ComposerNormal",
	},
      },
          colors = {
              bg = "#16161e",
              fg = "#ff9e64",
              red = "#ec5f67",
              blue = "#5fb3b3",
              green = "#99c794",
          },
      keymaps = {
	play_macro = "Q",
	yank_macro = "yq",
	stop_macro = "cq",
	toggle_record = "q",
	--cycle_next = "<c-n>",
	--cycle_prev = "<c-p>",
	toggle_macro_menu = "<leader>q",
      },
    })
  end,
}

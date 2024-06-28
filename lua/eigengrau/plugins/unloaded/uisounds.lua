return {
  "whleucka/reverb.nvim",
  event = "BufReadPre",
  opts = {
    sounds = {
      -- add custom sound paths for other events here
      -- eg. EVENT = "/some/path/to/sound.mp3"
      BufRead = { path = sound_dir .. "start.ogg", volume = 0-100 },
      CursorMovedI = { path = sound_dir .. "click.ogg", volume = 0-100 },
      InsertLeave = { path = sound_dir .. "toggle.ogg", volume = 0-100 },
      ExitPre = { path = sound_dir .. "exit.ogg", volume = 0-100 },
      BufWrite = { path = sound_dir .. "save.ogg", volume = 0-100 },
    },
  },
}

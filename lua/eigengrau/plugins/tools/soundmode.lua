return {
  "jackplus-xyz/player-one.nvim",
  lazy = true,
  cmd = {"PlayerOneToggle", "PlayerOneEnable", "PlayerOneDisable", "PlayerOneUpdate", "PlayerOneLoad"},
  opts = {
    auto_update = true,
    use_development = true, -- use development builds
    is_enabled = false,      -- Start with sounds disabled until explicitly enabled
    min_interval = 0.01,    -- Increase delay between sounds to 100ms
    master_volume = 0.2,    --'0.0' lowest, '1.0 highest', default '0,5'
    theme = "crystal",      -- sound themes: chiptune, crystal, synth
  },
}



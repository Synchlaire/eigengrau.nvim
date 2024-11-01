if vim.g.neovide then
  -- visual effects
  vim.o.guifont = "JuliaMono"
  vim.g.neovide_cursor_animate_command_line = true
  vim.g.neovide_cursor_animate_in_insert_mode = true
  vim.g.neovide_cursor_animation_length = 0.03
  vim.g.neovide_cursor_smooth_blink = true
  vim.g.neovide_floating_blur_amount_x = 1
  vim.g.neovide_floating_blur_amount_y = 1
  vim.g.neovide_floating_shadow = false
  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_refresh_rate_idle = 1
  vim.g.neovide_scroll_animation_length = 0.1
  vim.g.neovide_cursor_trail_length = 0.02
--  vim.g.neovide_cursor_vfx_mode = "ripple"
  --[[
		       Possible options are
		       "ripple"
		       "wireframe"
		       "pixiedust"
		       "sonicboom"
		       "torpedo"
		       "railgun"
		       ]]

  --  vim.g.neovide_cursor_vfx_particle_speed = 10.0
  --  vim.g.neovide_cursor_vfx_particle_lifetime = 3.2


  -- Font size: change with ctrl + plus/minus

  vim.g.neovide_scale_factor = 1.0
  local change_scale_factor = function(delta)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
  end
  vim.keymap.set("n", "<C-+>", function()
    change_scale_factor(1.25)
  end)
  vim.keymap.set("n", "<C-->", function()
    change_scale_factor(1/1.25)
  end)

  -- transparency

  -- Helper function for transparency formatting
  local alpha = function()
    return string.format("%x",
      math.floor(255 * (vim.g.transparency or 0.8)))
  end

  -- g:neovide_transparency should be 0 if you want to unify transparency of content and title bar.
  vim.g.neovide_transparency = 1.0
  vim.g.transparency = 1.8
  vim.g.neovide_background_color = "#0f1117" .. alpha()

  -- Padding
  vim.g.neovide_padding_top = 15
  vim.g.neovide_padding_bottom = 5
  vim.g.neovide_padding_right = 35
  vim.g.neovide_padding_left = 35
end

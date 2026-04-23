-- Exit early if not running in Neovide
if not vim.g.neovide then
	return
end

--====================================================================================================
-- NEOVIDE CONFIGURATION
-- Optimized for: ThinkPad 8th Gen Intel Core i5 + Intel UHD Graphics 620 + 8GB LPDDR3 RAM
-- Strategy: Balanced performance with smooth animations and visual effects
--====================================================================================================

--============================
-- Font & UI
--============================

-- vim.g.neovide_theme = 'dark'

--vim.opt.guifont = { "IBM Plex Mono" }
vim.opt.guifont = "Geist Mono:#e-subpixelantialias"
vim.g.neovide_pixel_geometry = "RGBH"
vim.g.neovide_text_gamma = 0.8
vim.g.neovide_text_contrast = 0.2

-- Quiet the 0.16 progress bar (LSP/long-op indicator) — clashes with minimal chrome
vim.g.neovide_progress_bar_enabled = true
vim.g.neovide_progress_bar_height = 2
-- General UI settings
vim.g.neovide_hide_mouse_when_typing = true
vim.g.neovide_padding_top = 15
vim.g.neovide_padding_bottom = 8
vim.g.neovide_padding_right = 15
vim.g.neovide_padding_left = 15
vim.g.neovide_opacity = 1
vim.g.neovide_normal_opacity = 1
vim.g.neovide_scale_factor = vim.g.neovide_scale_factor or 1.0
vim.opt.linespace = 1

--====================================================================================================
-- PERFORMANCE TUNING FOR INTEGRATED GRAPHICS
--====================================================================================================

-- Refresh rate settings: Intel UHD 620 can handle 60fps with proper throttling
-- Using adaptive refresh: max 60fps when active, 5fps idle to save battery
vim.g.neovide_refresh_rate = 100
vim.g.neovide_refresh_rate_idle = 5

-- Optimize idle behavior
vim.g.neovide_no_idle = false -- Allow idle optimization for battery life
vim.g.neovide_cursor_hack = true
vim.g.neovide_has_mouse_grid_detection = true

--====================================================================================================
-- VISUAL EFFECTS (Optimized for Integrated GPU)
--====================================================================================================

-- Floating windows: Shadow effect enabled (modern, minimal performance impact)
vim.g.neovide_floating_blur_amount_x = 0 -- Disable blur for stable low-power rendering
vim.g.neovide_floating_blur_amount_y = 0
vim.g.neovide_floating_shadow = true
vim.g.neovide_floating_z_height = 1
vim.g.neovide_light_angle_degrees = 2
vim.g.neovide_light_radius = 2
vim.g.neovide_floating_corner_radius = 0

-- Cursor animations: Smooth and responsive
vim.g.neovide_cursor_antialiasing = true
vim.g.neovide_cursor_animate_command_line = true
vim.g.neovide_cursor_animate_in_insert_mode = true
vim.g.neovide_cursor_animation_length = 0.08
vim.g.neovide_cursor_short_animation_length = 0.02
vim.g.neovide_cursor_smooth_blink = true
vim.g.neovide_cursor_cell_color_fallback = true

-- Cursor VFX (Visual Effects) - Enabled for eye candy
-- Possible modes: "ripple", "wireframe", "pixiedust", "sonicboom", "torpedo", "railgun"
-- vim.g.neovide_cursor_vfx_mode = "wireframe"
-- vim.g.neovide_cursor_vfx_opacity = 150
-- vim.g.neovide_cursor_vfx_particle_lifetime = 1.0
-- vim.g.neovide_cursor_vfx_particle_density = 5.0
vim.g.neovide_cursor_trail_size = 0.15

--====================================================================================================
-- SMOOTH SCROLLING (Primary performance optimization target)
--====================================================================================================

-- Enable smooth scrolling for better UX
vim.g.neovide_scroll_animation_length = 0.15
vim.g.neovide_position_animation_length = 0.01

-- Additional performance tuning
vim.g.neovide_underline_stroke_scale = 1.0 -- Crisp underlines
vim.g.neovide_cursor_unfocused_outline_width = 0.125 -- Reduce outline render cost

-- Critical setting: When to animate scrolling
-- 0 = no animations for page scrolling (best performance)
-- Large number = smooth animation for all scrolls (better UX, higher GPU load)
-- We use a moderate value: animate scrolls up to ~15 lines for smooth feel without GPU stress
vim.g.neovide_scroll_animation_far_lines = 15

-- Layer Grouping (experimental) - Keep disabled (causes blending artifacts, neovide#2574)
vim.g.experimental_layer_grouping = false

--============================
-- Keymaps
--============================

-- Font size adjustment (Ctrl + Plus/Minus)
vim.keymap.set("n", "<C-+>", function()
	vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * 1.1
end, { desc = "Neovide: Increase font size" })

vim.keymap.set("n", "<C-->", function()
	vim.g.neovide_scale_factor = vim.g.neovide_scale_factor / 1.1
end, { desc = "Neovide: Decrease font size" })

-- Transparency adjustment (Alt + a/s)
-- Note: A lower transparency value (e.g., 0.7) is MORE transparent.
local function adjust_transparency(delta)
	local current = vim.g.neovide_opacity or 1.0
	-- Clamp the value between 0.0 (fully transparent) and 1.0 (fully opaque)
	vim.g.neovide_opacity = math.max(0.0, math.min(1.0, current + delta))
end

-- Alt+a makes the window MORE transparent
vim.keymap.set("n", "<A-a>", function()
	adjust_transparency(-0.05)
end, {
	noremap = true,
	silent = true,
	desc = "Neovide: Increase transparency",
})

-- Alt+s makes the window MORE opaque
vim.keymap.set("n", "<A-s>", function()
	adjust_transparency(0.05)
end, {
	noremap = true,
	silent = true,
	desc = "Neovide: Decrease transparency",
})

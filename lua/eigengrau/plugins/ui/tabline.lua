-- Store custom tab names
_G.tab_names = {}

-- Function to set up colorscheme-aware tab highlights
local function setup_tab_highlights()
  -- Get colors from current colorscheme
  local normal_hl = vim.api.nvim_get_hl(0, { name = "Normal" })
  local tabline_sel_hl = vim.api.nvim_get_hl(0, { name = "TabLineSel" })
  local tabline_hl = vim.api.nvim_get_hl(0, { name = "TabLine" })
  local statement_hl = vim.api.nvim_get_hl(0, { name = "Statement" })

  -- Active tab: use TabLineSel colors with bold
  local active_fg = tabline_sel_hl.fg or normal_hl.fg or 15
  local active_bg = tabline_sel_hl.bg or normal_hl.bg or 0

  -- Inactive tab: use TabLine colors
  local inactive_fg = tabline_hl.fg or normal_hl.fg or 7
  local inactive_bg = tabline_hl.bg or normal_hl.bg or 0

  -- Underline color: use Statement (keywords/functions) color for visibility
  local underline_color = statement_hl.fg or active_fg

  -- Set highlight groups
  vim.api.nvim_set_hl(0, "ActiveTab", {
    fg = active_fg,
    bg = active_bg,
    bold = true,
    underline = true,
    sp = underline_color,
  })

  vim.api.nvim_set_hl(0, "InactiveTab", {
    fg = inactive_fg,
    bg = inactive_bg,
  })

  -- Short underline indicator (just a small bar)
  vim.api.nvim_set_hl(0, "ActiveTabIndicator", {
    fg = underline_color,
    bg = active_bg,
    bold = true,
  })
end

-- Set up highlights on load
setup_tab_highlights()

-- Update highlights when colorscheme changes
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = setup_tab_highlights,
  desc = "Update tab highlights for new colorscheme",
})

-- Global flags for clock, battery, and tab names display
_G.show_clock = false
_G.show_battery = false
_G.show_tab_names = true  -- Default to showing tab names

-- Get current time
local function get_clock()
  if not _G.show_clock then return "" end
  return " 󱑒 " .. os.date("%I:%M %p") .. " "
end

-- Get battery status
local function get_battery()
  if not _G.show_battery then return "" end

  local battery_file = "/sys/class/power_supply/BAT0/capacity"
  local status_file = "/sys/class/power_supply/BAT0/status"

  -- Check if battery files exist
  if vim.fn.filereadable(battery_file) == 0 then
    return ""
  end

  local capacity = vim.fn.readfile(battery_file)[1]
  local status = vim.fn.readfile(status_file)[1]

  -- Choose icon based on status and capacity
  local icon = ""
  if status == "Charging" then
    icon = "󱐋 " -- charging icon
  else
    local cap = tonumber(capacity)
    if cap >= 90 then
      icon = " "
    elseif cap >= 80 then
      icon = " "
    elseif cap >= 60 then
      icon = " "
    elseif cap >= 50 then
      icon = " "
    elseif cap >= 30 then
      icon = " "
    elseif cap >= 10 then
      icon = "  uh-oh.."
    elseif cap >= 5 then
      icon = "󰯈 i'm tired boss"
    else
      icon = " "
    end
  end

  return icon .. " " .. capacity .. "%% "
end

-- Update showtabline option based on conditions
local function update_showtabline()
  local total_tabs = vim.fn.tabpagenr("$")
  local should_show = _G.show_clock or _G.show_battery or total_tabs > 1

  -- 0 = never, 1 = only if there are at least two tabs, 2 = always
  vim.o.showtabline = should_show and 2 or 0
end

-- Toggle clock display
local function toggle_clock()
  _G.show_clock = not _G.show_clock
  update_showtabline()
  vim.cmd("redrawtabline")
  vim.notify("Clock " .. (_G.show_clock and "enabled" or "disabled"), vim.log.levels.INFO)
end

-- Toggle battery display
local function toggle_battery()
  _G.show_battery = not _G.show_battery
  update_showtabline()
  vim.cmd("redrawtabline")
  vim.notify("Battery " .. (_G.show_battery and "enabled" or "disabled"), vim.log.levels.INFO)
end

-- Toggle tab names display
local function toggle_tab_names()
  _G.show_tab_names = not _G.show_tab_names
  vim.cmd("redrawtabline")
  vim.notify("Tab names " .. (_G.show_tab_names and "enabled" or "disabled"), vim.log.levels.INFO)
end

-- Unified toggle for both battery and clock
local function toggle_statusline_info()
  local new_state = not (_G.show_battery or _G.show_clock)
  _G.show_battery = new_state
  _G.show_clock = new_state
  update_showtabline()
  vim.cmd("redrawtabline")
  vim.notify("Statusline info " .. (new_state and "enabled" or "disabled"), vim.log.levels.INFO)
end

-- Get tab name or fallback to buffer name
local function get_tab_name(tabnr)
  if _G.tab_names[tabnr] then
    return _G.tab_names[tabnr]
  end

  local buflist = vim.fn.tabpagebuflist(tabnr)
  local winnr = vim.fn.tabpagewinnr(tabnr)
  local bufnr = buflist[winnr]
  local bufname = vim.fn.bufname(bufnr)

  if bufname == "" then
    return "[No Name]"
  end

  return vim.fn.fnamemodify(bufname, ":t")
end

-- Custom tabline function with centered tabs
local function custom_tabline()
  local s = ""
  local current_tab = vim.fn.tabpagenr()
  local total_tabs = vim.fn.tabpagenr("$")

  -- Build tab info first to calculate total width
  local tab_info = {}
  local total_width = 0

  for i = 1, total_tabs do
    local tab_name = get_tab_name(i)
    local modified = false

    -- Check if any buffer in tab is modified
    local buflist = vim.fn.tabpagebuflist(i)
    for _, bufnr in ipairs(buflist) do
      if vim.fn.getbufvar(bufnr, "&modified") == 1 then
        modified = true
        break
      end
    end

    table.insert(tab_info, {name = tab_name, modified = modified})

    -- Calculate width for the label
    local label
    if _G.show_tab_names then
      label = string.format("%s%s", tab_name, modified and " 󰏭 " or "")
    else
      -- Both circles have same width, use empty circle for calculation
      label = string.format("○%s", modified and " 󰏭" or "")
    end

    -- Add 2 for the padding spaces for each tab
    total_width = total_width + vim.fn.strwidth(label) + 2
  end

  -- Calculate padding for centering
  local screen_width = vim.o.columns
  local padding = math.max(0, math.floor((screen_width - total_width) / 2))

  -- Add padding spaces
  s = s .. string.rep(" ", padding)

  -- Add tabs
  for i = 1, total_tabs do
    local info = tab_info[i]
    local label_text

    if _G.show_tab_names then
      label_text = string.format("%s%s", info.name, info.modified and " 󰏭 " or "")
    else
      -- Use filled circle for active tab, empty circle for inactive
      local circle = (i == current_tab) and "●" or "○"
      label_text = string.format("%s%s", circle, info.modified and " 󰏭" or "")
    end

    if i == current_tab then
      -- Active tab with short underline indicator
      s = s .. "%#TabLineSel# "
      s = s .. "%#ActiveTab#" .. label_text
      s = s .. "%#TabLineSel# "
    else
      -- Inactive tab
      s = s .. "%#InactiveTab# " .. label_text .. " "
    end
  end

  -- Fill remaining space
  s = s .. "%#TabLineFill#"

  -- Add clock and battery on the right side
  s = s .. "%=" -- Move to right side
  local right_components = ""

  local battery_text = get_battery()
  if battery_text ~= "" then
    right_components = right_components .. "%#TabLine#" .. battery_text
  end

  local clock_text = get_clock()
  if clock_text ~= "" then
    right_components = right_components .. "%#TabLine#" .. clock_text
  end

  s = s .. right_components

  return s
end

-- Rename current tab
local function rename_tab()
  local current_tab = vim.fn.tabpagenr()
  local current_name = _G.tab_names[current_tab] or get_tab_name(current_tab)

  vim.ui.input({
    prompt = "Tab name: ",
    default = current_name,
  }, function(input)
    if input and input ~= "" then
      _G.tab_names[current_tab] = input
      vim.cmd("redrawtabline")
      vim.notify("Tab renamed to: " .. input, vim.log.levels.INFO)
    end
  end)
end

-- Clear tab name (revert to default)
local function clear_tab_name()
  local current_tab = vim.fn.tabpagenr()
  _G.tab_names[current_tab] = nil
  vim.cmd("redrawtabline")
  vim.notify("Tab name cleared", vim.log.levels.INFO)
end

-- Auto-cleanup tab names when tabs are closed
vim.api.nvim_create_autocmd("TabClosed", {
  callback = function()
    -- Renumber tab names when a tab is closed
    local new_names = {}
    local current_tabs = vim.fn.tabpagenr("$")

    for i = 1, current_tabs do
      if _G.tab_names[i] then
        new_names[i] = _G.tab_names[i]
      end
    end

    _G.tab_names = new_names
    update_showtabline()
  end,
})

-- Update showtabline when tabs are created
vim.api.nvim_create_autocmd({ "TabNew", "TabEnter" }, {
  callback = function()
    update_showtabline()
  end,
})

-- Auto-refresh clock every minute
vim.fn.timer_start(60000, function()
  if _G.show_clock then
    vim.cmd("redrawtabline")
  end
end, { ["repeat"] = -1 })

-- Export functions for use
_G.custom_tabline = custom_tabline
_G.rename_tab = rename_tab
_G.clear_tab_name = clear_tab_name
_G.toggle_clock = toggle_clock
_G.toggle_battery = toggle_battery
_G.toggle_tab_names = toggle_tab_names
_G.toggle_statusline_info = toggle_statusline_info

-- Set custom tabline immediately
vim.o.tabline = "%!v:lua.custom_tabline()"

-- Set initial showtabline state
update_showtabline()

-- Create commands
vim.api.nvim_create_user_command("TabRename", function()
  _G.rename_tab()
end, {
  desc = "Rename current tab"
})

vim.api.nvim_create_user_command("TabClearName", function()
  _G.clear_tab_name()
end, {
  desc = "Clear custom tab name"
})

vim.api.nvim_create_user_command("ToggleClock", function()
  _G.toggle_clock()
end, {
  desc = "Toggle clock in tabline"
})

vim.api.nvim_create_user_command("ToggleBattery", function()
  _G.toggle_battery()
end, {
  desc = "Toggle battery in tabline"
})

vim.api.nvim_create_user_command("ToggleTabNames", function()
  _G.toggle_tab_names()
end, {
  desc = "Toggle tab names visibility"
})

vim.api.nvim_create_user_command("ToggleStatuslineInfo", function()
  _G.toggle_statusline_info()
end, {
  desc = "Toggle battery and clock together"
})

-- Note: Keybinds are defined in lua/eigengrau/config/keymaps.lua under <leader><Tab>

-- Return only the actual plugin
return {
  {
    "backdround/tabscope.nvim",
    event = "TabNewEntered",
    config = true,
    keys = {
      { "<space>dt", function() require("tabscope").remove_tab_buffer() end, desc = "Close local buffer" },
    },
  },
}

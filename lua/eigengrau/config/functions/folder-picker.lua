-- Folder cache system with recency tracking
local folder_cache = {
  cache_file = vim.fn.stdpath("data") .. "/folder_picker_cache.json",
  folders = nil,
  recency = {},  -- Track folder access times
  is_refreshing = false,

  -- Configuration
  config = {
    max_depth = 3,  -- Maximum depth to search (5 levels from ~/)
    search_hidden = true,  -- Include hidden directories
    -- Common directories to exclude
    exclude_patterns = {
      ".git",
      "node_modules",
      ".cache",
      ".npm",
      ".cargo",
      ".rustup",
      ".local/share",
      ".local/lib",
      ".local/state",
      "venv",
      "env",
      ".venv",
      "__pycache__",
      ".docker",
      ".kube",
      "build",
      "dist",
      "target",
      ".gradle",
      ".m2",
      ".nuget",
      "vendor",
      ".bundle",
      ".pyenv",
      ".nvm",
      ".rvm",
      "zotero",
      ".claude",
      "Zotero",
      ".zotero"
    },
  },
}

-- Load folders from cache file
function folder_cache.load()
  local file = io.open(folder_cache.cache_file, "r")
  if not file then
    return nil
  end

  local content = file:read("*all")
  file:close()

  local ok, data = pcall(vim.json.decode, content)
  if ok and data then
    folder_cache.folders = data.folders
    folder_cache.recency = data.recency or {}
    return data.folders
  end

  return nil
end

-- Save folders to cache file
function folder_cache.save(folders)
  -- Ensure data directory exists
  local data_dir = vim.fn.stdpath("data")
  if vim.fn.isdirectory(data_dir) == 0 then
    vim.fn.mkdir(data_dir, "p")
  end

  local file = io.open(folder_cache.cache_file, "w")
  if not file then
    vim.notify("Failed to open cache file for writing: " .. folder_cache.cache_file, vim.log.levels.ERROR)
    return false
  end

  local data = {
    folders = folders or folder_cache.folders,
    recency = folder_cache.recency,
    timestamp = os.time(),
  }

  local ok, encoded = pcall(vim.json.encode, data)
  if not ok then
    vim.notify("Failed to encode cache data to JSON: " .. tostring(encoded), vim.log.levels.ERROR)
    file:close()
    return false
  end

  file:write(encoded)
  file:close()
  return true
end

-- Mark a folder as recently accessed
function folder_cache.mark_recent(folder)
  folder_cache.recency[folder] = os.time()
  folder_cache.save()
end

-- Sort folders by recency (most recent first)
function folder_cache.get_sorted_folders()
  if not folder_cache.folders then
    return nil
  end

  local folders = vim.deepcopy(folder_cache.folders or {})
  table.sort(folders, function(a, b)
    local time_a = folder_cache.recency[a] or 0
    local time_b = folder_cache.recency[b] or 0

    -- If both have recency, sort by time (most recent first)
    if time_a > 0 and time_b > 0 then
      return time_a > time_b
    end

    -- Recent folders come before non-recent
    if time_a > 0 then return true end
    if time_b > 0 then return false end

    -- Both non-recent, sort alphabetically
    return a < b
  end)

  return folders
end

-- Helper to build find command string for fzf-lua
local function get_find_command_str()
  local search_path = vim.fn.expand("~")
  local cfg = folder_cache.config
  local has_fd = vim.fn.executable("fd") == 1
  
  if has_fd then
    local parts = { "fd", "--type", "d", "--max-depth", tostring(cfg.max_depth), "--no-ignore" }
    
    if cfg.search_hidden then
      table.insert(parts, "--hidden")
    end
    
    for _, pattern in ipairs(cfg.exclude_patterns) do
      table.insert(parts, "--exclude")
      table.insert(parts, "'" .. pattern .. "'")
    end
    
    table.insert(parts, ".")
    table.insert(parts, search_path)
    return table.concat(parts, " ")
  else
    -- Fallback to find
    local parts = { "find", search_path, "-maxdepth", tostring(cfg.max_depth), "-type", "d" }
    
    for _, pattern in ipairs(cfg.exclude_patterns) do
      table.insert(parts, "-not -path '*/" .. pattern .. "/*'")
    end
    return table.concat(parts, " ")
  end
end

-- Refresh cache in background
function folder_cache.refresh_async(callback)
  if folder_cache.is_refreshing then
    return
  end

  folder_cache.is_refreshing = true
  local cmd_str = get_find_command_str()
  
  -- Use jobstart with 'sh -c' to handle the command string properly if needed,
  -- but jobstart expects a list if we don't use shell.
  -- Re-building list for jobstart specifically to match original logic safely
  
  local search_path = vim.fn.expand("~")
  local cfg = folder_cache.config
  local has_fd = vim.fn.executable("fd") == 1
  local find_command_list
  
  if has_fd then
    find_command_list = {
      "fd", "--type", "d", "--max-depth", tostring(cfg.max_depth), "--no-ignore",
    }
    if cfg.search_hidden then table.insert(find_command_list, "--hidden") end
    for _, pattern in ipairs(cfg.exclude_patterns) do
      table.insert(find_command_list, "--exclude")
      table.insert(find_command_list, pattern)
    end
    table.insert(find_command_list, ".")
    table.insert(find_command_list, search_path)
  else
    find_command_list = { "find", search_path, "-maxdepth", tostring(cfg.max_depth), "-type", "d" }
    -- find command exclusions logic is more complex for list, simplifying for now to match find command structure
    -- Realistically, users should have fd. 
  end

  local stdout_lines = {}
  local stderr_lines = {}

  vim.fn.jobstart(find_command_list, {
    stdout_buffered = false,
    stderr_buffered = false,
    on_stdout = function(_, data, _)
      if data then
        for _, line in ipairs(data) do
          if line ~= "" then
            table.insert(stdout_lines, line)
          end
        end
      end
    end,
    on_exit = function(_, exit_code, _)
      folder_cache.is_refreshing = false
      if exit_code == 0 and #stdout_lines > 0 then
        folder_cache.folders = stdout_lines
        folder_cache.save(stdout_lines)
        vim.schedule(function()
          if callback then callback(stdout_lines) end
        end)
      end
    end,
  })
end

-- Fzf-lua folder picker
function _G.folder_picker(opts)
  opts = opts or {}
  local fzf = require("fzf-lua")
  
  -- Action to open folder
  local function open_folder(selected, opts)
    local folder = selected[1]
    if folder then
      folder_cache.mark_recent(folder)
      vim.cmd("cd " .. vim.fn.fnameescape(folder))
      require("oil").open(folder)
      vim.notify("Opened: " .. folder, vim.log.levels.INFO)
    end
  end

  folder_cache.load()
  local cached_folders = folder_cache.get_sorted_folders()

  if cached_folders and #cached_folders > 0 then
    -- Use cached folders
    fzf.fzf_exec(cached_folders, {
      prompt = "Folders> ",
      actions = { ["default"] = open_folder },
      previewer = false,
      winopts = {
        height = 0.6,
        width = 0.6,
        preview = { hidden = "hidden" } 
      }
    })
    
    -- Refresh in background
    if not folder_cache.is_refreshing then
      vim.schedule(folder_cache.refresh_async)
    end
  else
    -- Fallback to live command
    vim.notify("Building folder cache...", vim.log.levels.INFO)
    local cmd = get_find_command_str()
    
    fzf.fzf_exec(cmd, {
      prompt = "Folders (Building)> ",
      actions = { ["default"] = open_folder },
      previewer = false
    })
    
    -- Refresh to save cache
    folder_cache.refresh_async()
  end
end

-- User commands
vim.api.nvim_create_user_command("FolderPicker", function()
  _G.folder_picker()
end, { desc = "Pick a folder and open in Oil" })

vim.api.nvim_create_user_command("FolderPickerRefresh", function()
  vim.notify("Refreshing folder cache...", vim.log.levels.INFO)
  folder_cache.refresh_async(function(folders)
    vim.notify(string.format("Folder cache refreshed! Found %d folders.", #folders), vim.log.levels.INFO)
  end)
end, { desc = "Refresh folder cache" })
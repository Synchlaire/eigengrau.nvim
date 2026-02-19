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

-- Helper to build find command as list for jobstart
local function get_find_command_list()
  local search_path = vim.fn.expand("~")
  local cfg = folder_cache.config
  local has_fd = vim.fn.executable("fd") == 1

  if has_fd then
    local cmd = { "fd", "--type", "d", "--max-depth", tostring(cfg.max_depth), "--no-ignore" }
    if cfg.search_hidden then table.insert(cmd, "--hidden") end
    for _, pattern in ipairs(cfg.exclude_patterns) do
      table.insert(cmd, "--exclude")
      table.insert(cmd, pattern)
    end
    table.insert(cmd, ".")
    table.insert(cmd, search_path)
    return cmd
  else
    return { "find", search_path, "-maxdepth", tostring(cfg.max_depth), "-type", "d" }
  end
end

-- Refresh cache in background
function folder_cache.refresh_async(callback)
  if folder_cache.is_refreshing then
    return
  end

  folder_cache.is_refreshing = true
  local find_command_list = get_find_command_list()

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

-- Snacks.picker folder picker
function _G.folder_picker(opts)
  opts = opts or {}

  folder_cache.load()
  local cached_folders = folder_cache.get_sorted_folders()

  if cached_folders and #cached_folders > 0 then
    -- Build items from cached folders
    local items = {}
    for idx, folder in ipairs(cached_folders) do
      table.insert(items, { idx = idx, text = folder, file = folder })
    end

    Snacks.picker({
      title = "Folders",
      items = items,
      format = function(item)
        return { { item.text } }
      end,
      confirm = function(picker, item)
        picker:close()
        if item then
          folder_cache.mark_recent(item.text)
          vim.cmd("cd " .. vim.fn.fnameescape(item.text))
          require("oil").open(item.text)
          vim.notify("Opened: " .. item.text, vim.log.levels.INFO)
        end
      end,
    })

    -- Refresh in background
    if not folder_cache.is_refreshing then
      vim.schedule(folder_cache.refresh_async)
    end
  else
    -- No cache yet, build it first then open picker
    vim.notify("Building folder cache...", vim.log.levels.INFO)
    folder_cache.refresh_async(function(folders)
      vim.schedule(function()
        _G.folder_picker()
      end)
    end)
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
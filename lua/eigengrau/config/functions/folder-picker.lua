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

  local folders = vim.deepcopy(folder_cache.folders)

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

-- Refresh cache in background
function folder_cache.refresh_async(callback)
  if folder_cache.is_refreshing then
    return
  end

  folder_cache.is_refreshing = true

  local search_path = vim.fn.expand("~")
  local cfg = folder_cache.config

  -- Check if fd exists
  local has_fd = vim.fn.executable("fd") == 1
  local find_command

  if has_fd then
    find_command = {
      "fd",
      "--type", "d",
      "--max-depth", tostring(cfg.max_depth),
      "--no-ignore",
    }

    -- Add hidden flag if configured
    if cfg.search_hidden then
      table.insert(find_command, "--hidden")
    end

    -- Add all exclude patterns
    for _, pattern in ipairs(cfg.exclude_patterns) do
      table.insert(find_command, "--exclude")
      table.insert(find_command, pattern)
    end

    -- Add search pattern and path
    table.insert(find_command, ".")
    table.insert(find_command, search_path)
  else
    -- Build find command with exclusions
    find_command = {
      "find",
      search_path,
      "-maxdepth", tostring(cfg.max_depth),
      "-type", "d",
    }

    -- Add exclusions for find
    for _, pattern in ipairs(cfg.exclude_patterns) do
      table.insert(find_command, "-not")
      table.insert(find_command, "-path")
      table.insert(find_command, "*/" .. pattern .. "/*")
    end
  end

  local stdout_lines = {}
  local stderr_lines = {}

  vim.fn.jobstart(find_command, {
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
    on_stderr = function(_, data, _)
      if data then
        for _, line in ipairs(data) do
          if line ~= "" then
            table.insert(stderr_lines, line)
          end
        end
      end
    end,
    on_exit = function(_, exit_code, _)
      folder_cache.is_refreshing = false

      if exit_code ~= 0 then
        local error_msg = "Command failed with exit code " .. exit_code
        if #stderr_lines > 0 then
          error_msg = error_msg .. ": " .. table.concat(stderr_lines, "\n")
        end
        vim.schedule(function()
          vim.notify("Error refreshing folder cache: " .. error_msg, vim.log.levels.ERROR)
        end)
        return
      end

      if #stdout_lines > 0 then
        folder_cache.folders = stdout_lines
        folder_cache.save(stdout_lines)

        vim.schedule(function()
          if callback then
            callback(stdout_lines)
          end
        end)
      else
        vim.schedule(function()
          vim.notify("No folders found in cache refresh", vim.log.levels.WARN)
        end)
      end
    end,
  })
end

-- Telescope folder picker using fd with caching
-- Opens selected folder in oil.nvim and sets cwd
function _G.telescope_folder_picker(opts)
  opts = opts or {}

  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local entry_display = require("telescope.pickers.entry_display")

  -- Create entry maker for better display
  local displayer = entry_display.create({
    separator = " ",
    items = {
      { width = 30 },
      { remaining = true },
    },
  })

  local make_display = function(entry)
    local folder_name = vim.fn.fnamemodify(entry.value, ":t")
    local folder_path = vim.fn.fnamemodify(entry.value, ":h")

    -- If it's the home directory or root
    if folder_name == "" then
      folder_name = vim.fn.fnamemodify(entry.value, ":p:h:t")
    end

    return displayer({
      { folder_name, "TelescopeResultsIdentifier" },
      { "(" .. folder_path .. ")", "TelescopeResultsComment" },
    })
  end

  local entry_maker = function(line)
    return {
      value = line,
      display = make_display,
      ordinal = line,
      path = line,
    }
  end

  -- Try to load from cache first
  folder_cache.load()
  local cached_folders = folder_cache.get_sorted_folders()

  if cached_folders and #cached_folders > 0 then
    -- Use cached folders sorted by recency for instant display
    local picker = pickers.new(opts, {
      prompt_title = "Find Folders (recent first)",
      finder = finders.new_table({
        results = cached_folders,
        entry_maker = entry_maker,
      }),
      sorter = conf.file_sorter(opts),
      previewer = conf.file_previewer(opts),
      layout_strategy = "vertical",
      layout_config = {
        width = 0.95,
        height = 0.95,
        preview_height = 0.5,
      },
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)

          if selection then
            local folder = selection.value

            -- Mark as recently accessed
            folder_cache.mark_recent(folder)

            -- Set current working directory
            vim.cmd("cd " .. vim.fn.fnameescape(folder))

            -- Open oil in the selected folder
            require("oil").open(folder)

            -- Notify user
            vim.notify("Opened: " .. folder, vim.log.levels.INFO)
          end
        end)

        return true
      end,
    })

    -- Refresh cache in background for next time
    if not folder_cache.is_refreshing then
      vim.schedule(function()
        folder_cache.refresh_async()
      end)
    end

    picker:find()
  else
    -- No cache, do live search
    vim.notify("Building folder cache... (this can take a while )", vim.log.levels.INFO)

    local search_path = vim.fn.expand("~")
    local cfg = folder_cache.config
    local has_fd = vim.fn.executable("fd") == 1
    local find_command

    if has_fd then
      find_command = {
        "fd",
        "--type", "d",
        "--max-depth", tostring(cfg.max_depth),
        "--no-ignore",
      }

      -- Add hidden flag if configured
      if cfg.search_hidden then
        table.insert(find_command, "--hidden")
      end

      -- Add all exclude patterns
      for _, pattern in ipairs(cfg.exclude_patterns) do
        table.insert(find_command, "--exclude")
        table.insert(find_command, pattern)
      end

      -- Add search pattern and path
      table.insert(find_command, ".")
      table.insert(find_command, search_path)
    else
      -- Build find command with exclusions
      find_command = {
        "find",
        search_path,
        "-maxdepth", tostring(cfg.max_depth),
        "-type", "d",
      }

      -- Add exclusions for find
      for _, pattern in ipairs(cfg.exclude_patterns) do
        table.insert(find_command, "-not")
        table.insert(find_command, "-path")
        table.insert(find_command, "*/" .. pattern .. "/*")
      end
    end

    pickers.new(opts, {
      prompt_title = "Find Folders (building cache...)",
      finder = finders.new_oneshot_job(find_command, {
        entry_maker = entry_maker,
      }),
      sorter = conf.file_sorter(opts),
      previewer = conf.file_previewer(opts),
      layout_strategy = "vertical",
      layout_config = {
        width = 0.95,
        height = 0.95,
        preview_height = 0.5,
      },
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)

          if selection then
            local folder = selection.value

            -- Mark as recently accessed
            folder_cache.mark_recent(folder)

            -- Set current working directory
            vim.cmd("cd " .. vim.fn.fnameescape(folder))

            -- Open oil in the selected folder
            require("oil").open(folder)

            -- Notify user
            vim.notify("Opened: " .. folder, vim.log.levels.INFO)
          end
        end)

        return true
      end,
    }):find()

    -- Build cache for next time
    folder_cache.refresh_async()
  end
end

-- User commands
vim.api.nvim_create_user_command("FolderPicker", function()
  _G.telescope_folder_picker()
end, { desc = "Pick a folder and open in Oil" })

vim.api.nvim_create_user_command("FolderPickerRefresh", function()
  vim.notify("Refreshing folder cache...", vim.log.levels.INFO)
  folder_cache.refresh_async(function(folders)
    vim.notify(string.format("Folder cache refreshed! Found %d folders.", #folders), vim.log.levels.INFO)
  end)
end, { desc = "Refresh folder cache" })

vim.api.nvim_create_user_command("FolderPickerDebug", function()
  local cfg = folder_cache.config
  local info = {
    "=== Folder Picker Debug Info ===",
    "Cache file: " .. folder_cache.cache_file,
    "Cache exists: " .. (vim.fn.filereadable(folder_cache.cache_file) == 1 and "yes" or "no"),
    "Cached folders: " .. (folder_cache.folders and #folder_cache.folders or "not loaded"),
    "Recent folders: " .. vim.inspect(vim.tbl_keys(folder_cache.recency)),
    "Is refreshing: " .. tostring(folder_cache.is_refreshing),
    "fd available: " .. (vim.fn.executable("fd") == 1 and "yes" or "no"),
    "",
    "=== Configuration ===",
    "Max depth: " .. cfg.max_depth,
    "Search hidden: " .. tostring(cfg.search_hidden),
    "Excluded patterns: " .. #cfg.exclude_patterns .. " patterns",
  }
  vim.notify(table.concat(info, "\n"), vim.log.levels.INFO)
end, { desc = "Show folder picker debug info" })
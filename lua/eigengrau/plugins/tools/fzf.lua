return {
  "ibhagwan/fzf-lua",
  lazy = false,  -- Load early - many plugins depend on this
  cmd = "FzfLua",
  -- Primary fuzzy finder, replaces most telescope commands
  -- Keybindings:
  --   <leader>ff   - Find files
  --   <leader>fg   - Live grep
  --   <leader>fr   - Recent files
  --   <leader>fb   - Find buffers
  --   <leader>fx   - Command palette
  --   <leader>fg*  - Git operations (fgf/fgs/fgb/fgc)
  --   <leader>fw   - Grep word/selection
  dependencies = {
    "nvim-tree/nvim-web-devicons",  -- Optional but recommended for icons
  },
  config = function()
    local fzf = require("fzf-lua")

    -- ========================================================================
    -- FILE IGNORE PATTERNS - Skip unreadable/binary files
    -- ========================================================================
    -- These patterns exclude files that can't be edited or aren't worth searching
    local ignore_patterns = {
      -- Binary executables & compiled objects
      "%.exe", "%.dll", "%.so", "%.dylib", "%.o", "%.a", "%.obj", "%.class", "%.jar",
      -- Media files - images
      "%.jpeg", "%.jpg", "%.png", "%.gif", "%.webp", "%.svg", "%.ico", "%.bmp", "%.tiff", "%.webp",
      -- Media files - audio/video
      "%.mp3", "%.mp4", "%.webm", "%.avi", "%.mkv", "%.mov", "%.flv", "%.wav", "%.flac",
      "%.aac", "%.ogg", "%.opus", "%.m4a",
      -- Documents (binary/not meant for editing)
      "%.pdf", "%.epub", "%.docx", "%.doc", "%.xlsx", "%.xls", "%.pptx",
      -- Archives & compressed
      "%.zip", "%.rar", "%.7z", "%.tar", "%.gz", "%.bz2", "%.xz",
      -- Fonts
      "%.ttf", "%.otf", "%.woff", "%.woff2", "%.eot",
      -- Python caches & venvs
      "__pycache__", "%.pyc", "%.pyo", "%.pyd", "venv", ".venv",
      -- Node modules
      "node_modules", "%.npm",
      -- Ruby/gems
      "%.gem", "Gemfile%.lock",
      -- Build/dist directories
      "dist", "build", "target", "%.out", "%.class",
      -- Version control (shouldn't need to edit)
      "%.git", "%.svn", "%.hg", "%.gitignore",
      -- Cache/temp files
      "%cache%", "%.cache", "%.tmp", "%.temp", "%.swp", "%.swo",
      -- Database files
      "%.db", "%.sqlite", "%.sqlite3", "%.mdb",
      -- Minified files (hard to read)
      "%.min%.js", "%.min%.css",
      -- Generated/auto files
      "%.srt", "%courses%", "%.oil://%%",
    }

    -- Convert patterns to fd exclude format
    local fd_excludes = ""
    for _, pattern in ipairs(ignore_patterns) do
      -- Convert lua pattern to glob pattern
      local glob = pattern:gsub("%%", "*"):gsub("%%%.", "*."):gsub("%^", ""):gsub("%$", "")
      fd_excludes = fd_excludes .. " --exclude '" .. glob .. "'"
    end

    -- ========================================================================
    -- FZF-LUA CONFIGURATION
    -- ========================================================================

    fzf.setup({
      -- Fuzzy finder settings
      fzf_opts = {
        ["--ansi"] = true,              -- Support ANSI colors
        ["--info"] = "inline",          -- Show count inline
        ["--layout"] = "reverse",       -- Search at bottom
        ["--multi"] = true,             -- Multi-select with tab
        ["--tabstop"] = "4",            -- Tab width
        ["--bind"] = table.concat({
          "ctrl-a:select-all",
          "ctrl-d:deselect-all",
          "ctrl-/:toggle-preview",
          "ctrl-y:yank",
        }, ","),
      },

      -- Global settings
      defaults = {
        prompt = "  ",              -- Prompt prefix
        prompt_title_bg = "#1a1b26", -- Match background
        preview_title_bg = "#1a1b26",
        border = "rounded",
        scrollbar = "",             -- Hide scrollbar (cleaner)
        file_icons = true,          -- Show file type icons
        git_icons = false,          -- Don't need git icons for file finding
      },

      -- File finding
      files = {
        prompt = "Files> ",
        cwd_prompt = true,          -- Show current directory
        cmd = "fd --type f --hidden --exclude .git" .. fd_excludes, -- fd with filter patterns
        git_icons = false,
        file_icons = true,
        previewer = "builtin",      -- Use builtin previewer (respects colorscheme)
      },

      -- Directory finding
      directories = {
        prompt = "Dirs> ",
        cmd = "fd --type d --hidden --exclude .git",
        previewer = false,          -- Directories don't need preview
      },

      -- Buffer switching
      buffers = {
        prompt = "Buffers> ",
        previewer = false,
        sort_mru = true,            -- Show most recently used first
      },

      -- Live grep (text search using ripgrep)
      grep = {
        prompt = "Grep> ",
        input_prompt = "Grep for> ",
        previewer = "builtin",     -- Use builtin previewer (respects colorscheme)
        silent = true,             -- Hide fzf-lua info messages
        rg_opts = table.concat({
          "--color=always",         -- Color output
          "--no-heading",           -- Don't print filename for each match
          "--line-number",          -- Show line numbers
          "--smart-case",
          "--hidden",
          -- Use --glob patterns to exclude directories/files
          "--glob=!.git",
          "--glob=!node_modules",
          "--glob=!__pycache__",
          "--glob=!.venv",
          "--glob=!venv",
          "--glob=!dist",
          "--glob=!build",
          "--glob=!target",
          "--glob=!.cache",
          "--glob=!*.min.js",
          "--glob=!*.min.css",
        }, " "),
      },

      -- Help tags
      helptags = {
        prompt = "Help> ",
        previewer = "builtin",
      },

      -- Old files (recent files)
      oldfiles = {
        prompt = "Recent> ",
        cwd_only = false,
        include_current_session = true,
      },

      -- Git
      git = {
        files = {
          prompt = "Git Files> ",
          cmd = "git ls-files --cached --others --exclude-standard",
          previewer = "builtin",    -- Use builtin previewer (respects colorscheme)
        },
        status = {
          prompt = "Git Status> ",
        },
        commits = {
          prompt = "Git Commits> ",
        },
        branches = {
          prompt = "Git Branches> ",
        },
      },

      -- Keybindings within fzf
      keymap = {
        builtin = {
          ["<C-/>"] = "toggle-help",
          ["<C-a>"] = "select-all",
          ["<C-d>"] = "deselect-all",
          ["<C-l>"] = "toggle-fullscreen",
          ["<C-p>"] = "toggle-preview",
          -- Completion in live grep
          ["<C-k>"] = "up",
          ["<C-j>"] = "down",
        },
        fzf = {
          ["esc"] = "abort",
          ["ctrl-z"] = "unix-line-discard",
        },
      },

      -- Marks
      marks = {
        prompt = "Marks> ",
      },

      -- Command history
      command_history = {
        prompt = "Command> ",
      },

      -- Search history
      search_history = {
        prompt = "Search> ",
      },

      -- Window configuration
      winopts = {
        height = 0.85,
        width = 0.90,                 -- Wider to accommodate side-by-side preview
        row = 0.30,
        col = 0.05,
        preview = {
          hidden = false,               -- Show preview by default
          horizontal = "right:45%",     -- Show preview on RIGHT side, 45% width
          layout = "flex",              -- Flex layout for better space distribution
          scrollbar = false,            -- No scrollbar in preview
          delay = 100,                  -- Delay before showing preview
          border = "rounded",           -- Preview border style
          title_pos = "center",         -- Center preview title
        },
      },
    })

    -- ========================================================================
    -- KEYBINDINGS - Primary Search Commands
    -- ========================================================================
    -- Migrated from Telescope for better performance and preview support

    -- Find files (replaces telescope fd)
    vim.keymap.set("n", "<leader>ff", function()
      fzf.files()
    end, { desc = "Find files" })

    -- Live grep (replaces telescope live_grep)
    vim.keymap.set("n", "<leader>fg", function()
      fzf.live_grep()
    end, { desc = "Live grep" })

    -- Recent files (replaces telescope oldfiles)
    vim.keymap.set("n", "<leader>fr", function()
      fzf.oldfiles()
    end, { desc = "Recent files" })

    -- Find buffers
    vim.keymap.set("n", "<leader>fb", function()
      fzf.buffers()
    end, { desc = "Find buffers" })

    -- Command palette
    vim.keymap.set("n", "<leader>fx", function()
      fzf.commands()
    end, { desc = "Command palette" })

    -- ========================================================================
    -- GREP & SEARCH
    -- ========================================================================

    -- Grep word under cursor
    vim.keymap.set("n", "<leader>fw", function()
      fzf.grep_cword()
    end, { desc = "Grep word under cursor" })

    -- Grep visual selection
    vim.keymap.set("v", "<leader>fw", function()
      fzf.grep_visual()
    end, { desc = "Grep selection" })
  end,
}

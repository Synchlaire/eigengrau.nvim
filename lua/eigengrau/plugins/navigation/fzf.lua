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
      -- Use a nice profile as base
      "default-title",

      -- Fuzzy finder settings with visual enhancements
      fzf_opts = {
        ["--ansi"] = true,
        ["--info"] = "inline-right",     -- Show info on right (cleaner)
        ["--layout"] = "reverse-list",
        ["--multi"] = true,
        ["--height"] = "100%",
        ["--marker"] = "│",              -- Nice selection marker
        ["--pointer"] = "",             -- Arrow pointer
        ["--prompt"] = "  ",            -- Search icon prompt
        ["--border"] = "rounded",
        ["--separator"] = "─",           -- Visual separator
        ["--scrollbar"] = "│",           -- Scrollbar character
        ["--ellipsis"] = "…",            -- Truncation character
        ["--color"] = table.concat({
          "fg:#cccccc",
          "bg:#000000",
          "hl:#B6D6FD",                  -- Highlighted match
          "fg+:#E5E5E5",                 -- Current line foreground
          "bg+:#303030",                 -- Current line background
          "hl+:#B6D6FD",                 -- Highlighted match (current)
          "info:#999999",
          "prompt:#B6D6FD",              -- Prompt color
          "pointer:#E32791",             -- Selection pointer
          "marker:#5FD7A7",              -- Multi-select marker
          "spinner:#F3E430",
          "header:#4FB8CC",
          "border:#424242",              -- Border color
          "separator:#424242",           -- Separator color
        }, ","),
        ["--bind"] = table.concat({
          "ctrl-a:select-all",
          "ctrl-d:deselect-all",
          "ctrl-/:toggle-preview",
          "ctrl-u:preview-page-up",
          "ctrl-d:preview-page-down",
          "ctrl-y:yank",
          "alt-j:down",
          "alt-k:up",
        }, ","),
      },

      -- Global settings
      defaults = {
        prompt = "  ",
        file_icons = true,
        color_icons = true,
        git_icons = true,
        -- Prettier formatter for paths
        formatter = "path.filename_first",
      },

      -- File finding
      files = {
        prompt = "  ",
        winopts = {
          title = " 󰈞 Find Files ",
          title_pos = "center",
        },
        cwd_prompt = true,
        cmd = "fd --type f --hidden --exclude .git" .. fd_excludes,
        file_icons = true,
        color_icons = true,
        git_icons = true,
        previewer = "builtin",
      },

      -- Directory finding
      directories = {
        prompt = "  ",
        winopts = {
          title = "  Directories ",
          title_pos = "center",
        },
        cmd = "fd --type d --hidden --exclude .git",
        previewer = false,
      },

      -- Buffer switching
      buffers = {
        prompt = "  ",
        winopts = {
          title = " 󰈙 Buffers ",
          title_pos = "center",
        },
        previewer = false,
        sort_mru = true,
        file_icons = true,
        color_icons = true,
      },

      -- Live grep (text search using ripgrep)
      grep = {
        prompt = "  ",
        winopts = {
          title = "  Live Grep ",
          title_pos = "center",
        },
        input_prompt = "Grep for  ",
        previewer = "builtin",
        silent = true,
        rg_opts = table.concat({
          "--color=always",
          "--no-heading",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden",
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
        prompt = "  ",
        winopts = {
          title = " 󰋖 Help Tags ",
          title_pos = "center",
        },
        previewer = "builtin",
      },

      -- Old files (recent files)
      oldfiles = {
        prompt = "  ",
        winopts = {
          title = " 󰋚 Recent Files ",
          title_pos = "center",
        },
        cwd_only = false,
        include_current_session = true,
        file_icons = true,
        color_icons = true,
      },

      -- Git
      git = {
        files = {
          prompt = "  ",
          winopts = {
            title = "  Git Files ",
            title_pos = "center",
          },
          cmd = "git ls-files --cached --others --exclude-standard",
          previewer = "builtin",
          file_icons = true,
          color_icons = true,
        },
        status = {
          prompt = " 󰊢 ",
          winopts = {
            title = " 󰊢 Git Status ",
            title_pos = "center",
          },
        },
        commits = {
          prompt = "  ",
          winopts = {
            title = "  Git Commits ",
            title_pos = "center",
          },
        },
        branches = {
          prompt = "  ",
          winopts = {
            title = "  Git Branches ",
            title_pos = "center",
          },
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
        prompt = "  ",
        winopts = {
          title = "  Marks ",
          title_pos = "center",
        },
      },

      -- Command history
      command_history = {
        prompt = "  ",
        winopts = {
          title = "  Command History ",
          title_pos = "center",
        },
      },

      -- Search history
      search_history = {
        prompt = "  ",
        winopts = {
          title = "  Search History ",
          title_pos = "center",
        },
      },

      -- Commands
      commands = {
        prompt = "  ",
        winopts = {
          title = "  Commands ",
          title_pos = "center",
        },
      },

      -- Window configuration - CENTERED AND BEAUTIFUL
      winopts = {
        height = 0.85,
        width = 0.85,
        row = 0.5,                        -- Centered vertically (0.5 = middle)
        col = 0.5,                        -- Centered horizontally (0.5 = middle)
        border = "rounded",
        hl = {
          normal = "Normal",
          border = "FloatBorder",
          title = "Title",
          preview_border = "FloatBorder",
          preview_title = "Title",
        },
        preview = {
          hidden = "hidden",              -- Start with preview (toggle with ctrl-/)
          vertical = "down:50%",          -- Preview below, 50% height
          horizontal = "right:50%",       -- Or right side, 50% width
          layout = "flex",                -- Flex layout adapts to content
          flip_columns = 120,             -- Switch layout at this width
          scrollbar = "border",           -- Show scrollbar on border
          scrolloff = "-2",
          delay = 50,                     -- Fast preview
          winopts = {
            number = true,
            relativenumber = false,
            cursorline = true,
            cursorlineopt = "both",
            signcolumn = "no",
            list = false,
          },
          title = true,
          title_pos = "center",
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

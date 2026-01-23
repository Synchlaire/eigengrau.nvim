return {
  "ibhagwan/fzf-lua",
  lazy = true,
  cmd = "FzfLua",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    { "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find Files (Root)" },
    { "<leader>fF", "<cmd>FzfLua files cwd=~<cr>", desc = "Find Files (Home)" },
    { "<leader>fg", "<cmd>FzfLua live_grep<cr>", desc = "Live Grep" },
    { "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "Buffers" },
    { "<leader>fr", "<cmd>FzfLua oldfiles<cr>", desc = "Recent Files" },
    { "<leader>fw", "<cmd>FzfLua grep_cword<cr>", desc = "Grep Word" },
    { "<leader>fx", "<cmd>FzfLua commands<cr>", desc = "Commands" },
    { "<leader>fk", "<cmd>FzfLua keymaps<cr>", desc = "Keymaps" },
    { "<leader>fs", "<cmd>FzfLua lsp_document_symbols<cr>", desc = "Document Symbols" },
    { "<leader>fp", "<cmd>FolderPicker<cr>", desc = "Project Explorer" },
  },
  config = function()
    local fzf = require("fzf-lua")

    -- ========================================================================
    -- FILE IGNORE PATTERNS - Skip unreadable/binary files
    -- ========================================================================
    local ignore_patterns = {
      "%.exe", "%.dll", "%.so", "%.dylib", "%.o", "%.a", "%.obj", "%.class", "%.jar",
      "%.jpeg", "%.jpg", "%.png", "%.gif", "%.webp", "%.svg", "%.ico", "%.bmp", "%.tiff",
      "%.mp3", "%.mp4", "%.webm", "%.avi", "%.mkv", "%.mov", "%.flv", "%.wav", "%.flac",
      "%.pdf", "%.epub", "%.docx", "%.doc", "%.xlsx", "%.xls", "%.pptx",
      "%.zip", "%.rar", "%.7z", "%.tar", "%.gz", "%.bz2", "%.xz",
      "%.ttf", "%.otf", "%.woff", "%.woff2", "%.eot",
      "__pycache__", "%.pyc", "%.pyo", "%.pyd", "venv", ".venv",
      "node_modules", "%.npm",
      "%.gem", "Gemfile%.lock",
      "dist", "build", "target", "%.out",
      "%.git", "%.svn", "%.hg", "%.gitignore",
      "%cache%", "%.cache", "%.tmp", "%.temp", "%.swp", "%.swo",
      "%.db", "%.sqlite", "%.sqlite3", "%.mdb",
      "%.min%.js", "%.min%.css",
      "%.srt", "%courses%", "%.oil://%%",
    }

    local fd_excludes = ""
    for _, pattern in ipairs(ignore_patterns) do
      local glob = pattern:gsub("%%", "*"):gsub("%%%.", "*."):gsub("%^", ""):gsub("%$", "")
      fd_excludes = fd_excludes .. " --exclude '" .. glob .. "'"
    end

    -- ========================================================================
    -- FZF-LUA CONFIGURATION
    -- ========================================================================

    fzf.setup({
      -- Fuzzy finder settings
      fzf_opts = {
        ["--ansi"] = true,
        ["--info"] = "inline",
        ["--layout"] = "reverse",
        ["--multi"] = true,
        ["--tabstop"] = "4",
        ["--bind"] = table.concat({
          "ctrl-a:select-all",
          "ctrl-d:deselect-all",
          "ctrl-/:toggle-preview",
          "ctrl-y:yank",
        }, ","),
      },

      -- Global settings
      defaults = {
        prompt = "  ",
        prompt_title_bg = "#1a1b26",
        preview_title_bg = "#1a1b26",
        border = "rounded",
        scrollbar = "",
        file_icons = true,
        git_icons = false,
      },

      -- File finding
      files = {
        prompt = "Files> ",
        cwd_prompt = true,
        cmd = "fd --type f --hidden --exclude .git" .. fd_excludes,
        git_icons = false,
        file_icons = true,
        previewer = "builtin",
      },

      -- Directory finding
      directories = {
        prompt = "Dirs> ",
        cmd = "fd --type d --hidden --exclude .git",
        previewer = false,
      },

      -- Buffer switching
      buffers = {
        prompt = "Buffers> ",
        previewer = false,
        sort_mru = true,
      },

      -- Live grep
      grep = {
        prompt = "Grep> ",
        input_prompt = "Grep for> ",
        previewer = "builtin",
        silent = true,
        rg_opts = table.concat({
          "--color=always",
          "--no-heading",
          "--line-number",
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

      -- Git
      git = {
        files = {
          prompt = "Git Files> ",
          cmd = "git ls-files --cached --others --exclude-standard",
          previewer = "builtin",
        },
      },

      -- Window configuration
      winopts = {
        height = 0.85,
        width = 0.90,
        row = 0.50,
        col = 0.50,
        preview = {
          hidden = false,
          horizontal = "right:45%",
          layout = "flex",
          scrollbar = false,
          delay = 100,
          border = "rounded",
          title_pos = "center",
        },
      },
    })
    
    fzf.register_ui_select()
  end,
}

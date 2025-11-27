
return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {

    --[[
AVAILABLE MODULES
===================
animate      - Efficient animations including over 45 easing functions (library)
bigfile      - Deal with big files -- [needs config]
bufdelete    - Delete buffers without disrupting window layout
dashboard    - Beautiful declarative dashboards -- [needs config]
debug        - Pretty inspect & backtraces for debugging
dim          - Focus on the active scope by dimming the rest
git          - Git utilities
gitbrowse    - Open the current file, branch, commit, or repo in a browser
indent       - Indent guides and scopes
input        - Better vim.ui.input -- [needs config]
lazygit      - Open LazyGit in a float, auto-configure colorscheme and integration with Neovim
notifier     - Pretty vim.notify -- [needs config]
notify       - Utility functions to work with Neovim's vim.notify
profiler     - Neovim lua profiler
quickfile    - When doing nvim somefile.txt, it will render the file as quickly as possible, before loading your plugins. -- [needs config]
rename       - LSP-integrated file renaming with support for plugins like neo-tree.nvim and mini.files.
scope        - Scope detection, text objects and jumping based on treesitter or indent -- [needs config]
scratch      - Scratch buffers with a persistent file
scroll       - Smooth scrolling -- [needs config]
statuscolumn - Pretty status column -- [needs config]
terminal     - Create and toggle floating/split terminals
toggle       - Toggle keymaps integrated with which-key icons / colors
util         - Utility functions for Snacks (library)
win          - Create and manage floating windows or splits
words        - Auto-show LSP references and quickly navigate between them -- [needs config]
zen          - Zen mode • distraction-free coding
]]


    -- [Module Settings]

    -- Easy setup
    bigfile = { enabled = true, notify = true }, --performance for big files
    input = { enabled = false },
    notify = { enabled = true },
    quickfile = { enabled = true }, -- performance on file rendering
    scratch = { enabled = false },
    win = { enabled = true },
    toggle = { enabled = true },
    profiler = { enabled = true },
    scope = { enabled = true },  -- Better scope detection
    words = { enabled = true },  -- Auto-highlight LSP references under cursor
    dim = { enabled = true },    -- Focus mode for prose writing

    -- Detailed setup
    notifier = {
      enabled = true,
      timeout = 3000, -- default timeout in ms
      width = { min = 40, max = 0.4 },
      height = { min = 1, max = 0.6 },
      margin = { top = 0, right = 1, bottom = 0 },
      top_down = true,   -- place notifications from top to bottom
      more_format = " ↓ %d lines ",
      style = "compact", -- compact, fancy, minimal
      border = "rounded",
      ft = "markdown",
      wo = { winblend = 5, wrap = true }
    },

    indent = {
      enabled = false,     -- enable indent guides
      char = "│",
      only_scope = true,   -- only show indent guides of the scope
      only_current = true, -- only show indent guides in the current window
    },

    scroll = {
      enabled = false,
      animate = {
        duration = { step = 15, total = 150 },
        easing = "linear",
      },
    },

    image = {
      enabled = true,
      formats = {
        "png",
        "jpg",
        "jpeg",
        "gif",
        "bmp",
        "webp",
        "tiff",
        "heic",
        "avif",
        "mp4",
        "mov",
        "avi",
        "mkv",
        "webm",
        "pdf",
      },
      doc = {
        enabled = true,
        inline = true,
        float = true,
        focusable = false,
        backdrop = false,
        relative = 'cursor',
        border = 'rounded',
        max_width = 50,
        max_height = 25,
      },
    },


    statuscolumn = {
      enabled = false,
      left = { "mark", "sign" },
      right = { "fold", "git" },
      folds = {
        open = false,  -- show open folds
        git_hl = true, -- use gitsigns hl for fold icons
      },
      refresh = 100,   -- refresh at most every 100ms
    },



    dashboard = {
      enabled = true,
      pane_gap = 4,
      preset = {
        --        header = [[
        -- ⠀⠀⠀⠀⠀⠀⢀⣤⣶⣶⣖⣦⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀
        -- ⠀⠀⠀⠀⢀⣾⡟⣉⣽⣿⢿⡿⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀
        -- ⠀⠀⠀⢠⣿⣿⣿⡗⠋⠙⡿⣷⢌⣿⣿⠀⠀⠀⠀⠀⠀⠀
        -- ⣷⣄⣀⣿⣿⣿⣿⣷⣦⣤⣾⣿⣿⣿⡿⠀⠀⠀⠀⠀⠀⠀
        -- ⠈⠙⠛⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⡀⠀⢀⠀⠀⠀⠀
        -- ⠀⠀⠀⠸⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠻⠿⠿⠋⠀⠀⠀⠀
        -- ⠀⠀⠀⠀⠹⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀
        -- ⠀⠀⠀⠀⠀⠈⢿⣿⣿⣿⣿⣿⣿⣇⠀⠀⠀⠀⠀⠀⠀⡄
        -- ⠀⠀⠀⠀⠀⠀⠀⠙⢿⣿⣿⣿⣿⣿⣆⠀⠀⠀⠀⢀⡾⠀
        -- ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣿⣿⣿⣿⣷⣶⣴⣾⠏⠀⠀
        -- ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠛⠛⠛⠋⠁⠀⠀⠀
        --      ]],

--         header = [[
--
-- ⣼⢧⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
-- ⢻⡈⠻⣦⣀⣀⣀⣀⣀⠀⠀⠀⠀
-- ⡿⠳⣤⣀⡀⠀⠀⠉⠉⠉⠳⢦⠀
-- ⠻⣦⣀⠀⠀⠀⡴⠶⢦⡀⠀⠈⣿
-- ⠀⠸⣍⣉⣁⡀⣇⠀⠀⠑⠀⢠⡿
-- ⠀⠀⠀⠙⠷⠤⠿⠶⠦⠶⠞⠋⠀
-- ]],

        header = [[
⠀⠀⠀⠀⠀⠀⣾⠍⠁⠉⣷⠀⠀⠀⠀⠀⠀⣠⣤⣤⡀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⣿⡃⠀⠀⠀⢘⣿⠀⠀⠀⢠⣾⡟⠃⠀⠛⣿⡆⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⣿⡅⠀⠀⠀⣨⡿⠀⠀⢠⡞⠃⠀⠀⠀⠀⠙⣿⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠙⣶⡀⠀⠐⣿⣠⢶⡶⣾⠀⠀⠀⠀⣀⡤⠄⣿⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⣷⠀⠀⠀⠉⠀⠀⠀⠈⠳⠶⠏⠋⠁⣶⡋⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⣶⡋⠀⠀⣶⣶⠀⠀⠀⠀⢰⣶⡆⠀⠀⠉⣷⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⣿⡁⠀⠀⠿⠟⠀⠀⠀⠀⠸⠿⠇⠀⠀⠀⣿⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠈⠻⣤⣄⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⣠⡾⠋⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠛⠛⠛⠛⠛⠛⠛⠛⠛⠋⠀⠀⠀⠀⠀⠀⠀⠀
]],

        keys = {
          { key = "s", icon  = "", desc = "Sessions", action = "<cmd>Telescope possession list theme=dropdown initial_mode=normal<cr>" },
          { key = "n", icon  = "", desc = "New file", action = "<cmd>ene<cr>" },
          { key = "o", icon  = "", desc = "Obsidian", action = "<cmd>Obsidian<cr>" },
          { key = "p", icon  = "󱅄", desc = "Projects", action = "<cmd>ProjectExplorer<cr>" },
          { key = "l", icon  = "󱈼", desc = "Lazy Plugins", action = "<cmd>Lazy<cr>" },
          { key = "f", icon  = "", desc = "Find file", action = "<cmd>lua Snacks.dashboard.pick('files')<cr>" },
          { key = "d", icon  = "", desc = "Find Folders", action = "<cmd>FolderPicker<cr>" },
          { key = "r", icon  = "", desc = "Recent files", action = "<cmd>lua Snacks.dashboard.pick('oldfiles')<cr>" },
          { key = "cc", icon = "", desc = "system configs", action = "<cmd>cd $HOME/.config/ | lua Snacks.dashboard.pick('files')<cr>" },
          { key = "cn", icon = "", desc = "nvim config", action = "<cmd>cd $HOME/.config/nvim/ | lua Snacks.dashboard.pick('files')<cr>" },
          { key = "qq", icon = "", desc = "Quit NVIM", action = "<cmd>qa<cr>" },
        },
      },
      formats = {
        key = function(item)
          return { { "[", hl = "special" }, { item.key, hl = "key" }, { "]", hl = "special" } }
        end,
        header = { "%s", align = "center" },
        footer = { "%s", align = "center" },
      },
      sections = {
        { pane = 1, section = "header",       gap = 1 },
        --        { pane = 1, section = "terminal", cmd = "", gap = 1 },
        { pane = 2, title = "# Recent Files", section = "recent_files", limit = 5, indent = 2, padding = 1 },
        { pane = 2, title = "# Keymaps",      section = "keys",         indent = 2, padding = 1 },
        { pane = 2, section = "startup",      gap = 1 },
      },
    },
  },
}

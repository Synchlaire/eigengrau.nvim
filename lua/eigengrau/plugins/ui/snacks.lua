return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  keys = {
    { "<leader>ff", function() Snacks.picker.files() end,                       desc = "Find Files" },
    { "<leader>fF", function() Snacks.picker.files({ cwd = vim.env.HOME }) end, desc = "Files in Home" },
    { "<leader>fg", function() Snacks.picker.grep() end,                        desc = "Live Grep" },
    { "<leader>gf", function() Snacks.picker.git_files() end,                   desc = "Git Files" },
    { "<leader>gg", function() Snacks.picker.git_grep() end,                    desc = "Git Grep" },
    { "<leader>fw", function() Snacks.picker.grep_word() end,                   desc = "Grep Word" },
    { "<leader>fr", function() Snacks.picker.recent() end,                      desc = "Recent Files" },
    { "<leader>fb", function() Snacks.picker.buffers() end,                     desc = "Buffers" },
    { "<leader>fs", function() Snacks.picker.lsp_symbols() end,                 desc = "Document Symbols" },
    { "<leader>fS", function() Snacks.picker.workspace_symbols() end,           desc = "Workspace Symbols" },
    { "<leader>fh", function() Snacks.picker.help_tags() end,                   desc = "Help Tags" },
    { "<leader>fx", function() Snacks.picker.commands() end,                    desc = "Commands" },
    { "<leader>fk", function() Snacks.picker.keymaps() end,                     desc = "Keymaps" },
    { "<leader>f.", function() Snacks.picker.resume() end,                      desc = "Resume Last Picker" },
  },
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
    picker = {
      enabled = true,
      prompt = " ",
      layout = {
        border = "single",
        width = 0.8,
        height = 0.75,
        min_width = 90,
        min_height = 24,
        cycle = true,
        preset = function()
          if vim.o.columns >= 120 and vim.o.lines >= 40 then
            return "default"
          end
          return "ivy"
        end,
      },
      win = {
        input = {
          border = "single",
          backdrop = false,
        },
        list = {
          border = "none",
          wo = {
            cursorline = true,
            concealcursor = "n",
          },
        },
        preview = {
          border = "single",
          wo = {
            winblend = 5,
          },
        },
      },
      formatters = {
        file = {
          filename_first = true,
          truncate = 80,
        },
      },
      previewers = {
        file = {
          max_size = 2 * 1024 * 1024,
        },
      },
      sources = {
        files = {
          prompt = "󰈞 ",
          layout = { preview = false },
        },
        grep = {
          prompt = "󰐰 ",
          layout = { preview = true },
        },
        buffers = {
          prompt = "󰓩 ",
          layout = { preview = false },
        },
        recent = {
          prompt = "󰄉 ",
          layout = { preview = false },
        },
        git_files = {
          prompt = "󰊢 ",
          layout = { preview = false },
        },
        git_grep = {
          prompt = "󰊢 ",
          layout = { preview = true },
        },
        commands = {
          prompt = "󰘳 ",
        },
        keymaps = {
          prompt = "󰌌 ",
        },
        help = {
          prompt = "󰘥 ",
        },
        lsp_symbols = {
          prompt = "󰒕 ",
        },
        workspace_symbols = {
          prompt = "󰒕 ",
        },
      },
    },                                           -- Required for obsidian.nvim picker backend
    bigfile = { enabled = true, notify = true }, --performance for big files
    input = { enabled = false },
    notify = { enabled = true },
    quickfile = { enabled = true }, -- performance on file rendering
    scratch = { enabled = false },
    win = { enabled = true },
    toggle = { enabled = true },
    profiler = { enabled = true },
    scope = { enabled = false },  -- Better scope detection
    words = { enabled = true },   -- Auto-highlight LSP references under cursor
    dim = { enabled = false },    -- Focus mode for prose writing
    lazygit = { enabled = true }, -- Git TUI integration

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
      preset = {
        header = [[
        L I T T L E W I N G
]],
        keys = {
          { key = "n", icon = " ", desc = "New file", action = ":ene | startinsert" },
          { key = "f", icon = "󰈞 ", desc = "Find files", action = ":lua Snacks.picker.files()" },
          { key = "r", icon = "󰄉 ", desc = "Recent files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { key = "p", icon = "󰉋 ", desc = "Projects", action = ":Project" },
          { key = "s", icon = " ", desc = "Sessions", action = ":ProjectSession" },
          { key = "i", icon = "󰭻 ", desc = "99 search", action = ":lua require('99').search()" },
          { key = "l", icon = "󰒲 ", desc = "Lazy", action = ":Lazy" },
          { key = "c", icon = " ", desc = "Config", action = ":lua Snacks.picker.files({ cwd = vim.fn.stdpath('config') })" },
          { key = "q", icon = " ", desc = "Quit", action = ":qa" },
        },
      },
      sections = {
        { pane = 1, section = "header",     gap = 0 },
        { pane = 1, title = "Recent Files", section = "recent_files", limit = 3, indent = 2, gap = 0, padding = 1 },
        { pane = 2, title = "Commands",     section = "keys",         gap = 0,   padding = 1 },
        { pane = 2, section = "startup",    gap = 1 },
      },
    },
  },
  config = function(_, opts)
    -- Load ASCII headers
    local ascii = require("eigengrau.utils.ascii")

    -- Pick a specific header (change this to use a different one)
    -- Available: zzz, kewl_cat, ghost, bnuy, cat1, wing
    opts.dashboard.preset.header = ascii.wing

    require("snacks").setup(opts)
  end,
}

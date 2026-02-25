return {
  "DanielPonte01/ink.nvim",
  cmd = { "InkOpen", "InkLibrary" },
  keys = {
    { "<leader>eL", desc = "Open EPUB library" },
    { "<leader>el", desc = "Open last book" },
    { "<leader>eo", ":InkOpen ",               desc = "Open EPUB file" },
  },
  dependencies = {
    -- "nvim-telescope/telescope.nvim",  -- Optional: for search features
  },
  config = function()
    require("ink").setup({
      -- Display settings
      focused_mode = true, -- Enable focused reading mode
      image_open = true,   -- Allow opening images in external viewer
      justify_text = true, -- Enable text justification (adds spaces between words)
      max_width = 88,      -- Maximum text width (for centering)
      width_step = 5,      -- How much to change width per keypress

      -- Navigation keymaps
      keymaps = {
        next_chapter = "]c",      -- Navigate to next chapter
        prev_chapter = "[c",      -- Navigate to previous chapter
        toggle_toc = "<leader>/", -- Toggle table of contents sidebar
        activate = "<CR>",        -- Preview footnote or open image/TOC entry
        jump_to_link = "g<CR>",   -- Jump to link target (footnotes, cross-references)

        -- Search features (requires telescope.nvim)
        -- search_toc = "<leader>pit",           -- Search/filter chapters by name
        -- search_content = "<leader>pif",       -- Search text within all chapters
        -- search_mode_toggle = "<C-f>",         -- Toggle between TOC and content search

        -- Width adjustment
        width_increase = "<leader>+", -- Increase text width
        width_decrease = "<leader>-", -- Decrease text width
        width_reset = "<leader>=",    -- Reset text width to default

        -- Library (global keymaps)
        library = "<leader>eL",   -- Open library browser
        last_book = "<leader>el", -- Open last read book
      },

      -- Highlight colors (customize with any hex colors you want)
      highlight_colors = {
        yellow = { bg = "#f9e2af", fg = "#000000" },
        green = { bg = "#a6e3a1", fg = "#000000" },
        red = { bg = "#f38ba8", fg = "#000000" },
        blue = { bg = "#89b4fa", fg = "#000000" },
        -- Add more colors: purple, orange, pink, etc.
        -- purple = { bg = "#cba6f7", fg = "#000000" },
      },

      -- Highlight keymaps (visual mode for adding, normal mode for removing)
      highlight_keymaps = {
        yellow = "<leader>hy", -- Highlight selection in yellow
        green = "<leader>hg",  -- Highlight selection in green
        red = "<leader>hr",    -- Highlight selection in red
        blue = "<leader>hb",   -- Highlight selection in blue
        remove = "<leader>hx"  -- Remove highlight under cursor
        -- Add more colors: purple, orange, pink, etc.
        -- purple = "<leader>hp",    -- Highlight with your custom highlight
      },

      -- Note keymaps (for annotations on highlights)
      note_keymaps = {
        add = "<leader>na",           -- Add/edit note on highlight under cursor
        remove = "<leader>nd",        -- Remove note from highlight
        toggle_display = "<leader>nt" -- Toggle note display (off/indicator/expanded)
      },

      -- Bookmark keymaps
      bookmark_keymaps = {
        add = "<leader>ba",       -- Add/edit bookmark at paragraph
        remove = "<leader>bd",    -- Remove bookmark at paragraph
        next = "<leader>bn",      -- Go to next bookmark
        prev = "<leader>bp",      -- Go to previous bookmark
        list_all = "<leader>bl",  -- List all bookmarks (global)
        list_book = "<leader>bb", -- List bookmarks in current book (global)
      },
      bookmark_icon = "  "        -- Bookmark icon
    })
  end
}

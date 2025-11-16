return {
  -- Telescope plugins
  'nvim-telescope/telescope.nvim',
  lazy = true,
  cmd = { "Telescope" },
  keys = {
    { '<leader>fd', '<cmd>Telescope fd<CR>',        desc = 'Find files across system' },
    { '<leader>fg', '<cmd>Telescope live_grep<CR>', desc = 'live grep' },
    { '<leader>ff', '<cmd>Telescope oldfiles<CR>',  desc = 'search recent files' },
    { '<leader>fh', '<cmd>Telescope help_tags<CR>', desc = 'help tags' },
  },

  dependencies = {
    { 'BurntSushi/ripgrep' },
    { 'keyvchan/telescope-find-pickers.nvim',    lazy = true },
    { 'nvim-telescope/telescope-ui-select.nvim', lazy = true },
  },
  config = function()
    -- set locals for conciseness
    local ignore_filetypes_list = { "venv", "__pycache__", "%.jpeg", "%.jpg",
      "%.png", "%.webp", "%.svg", "%.pdf", "%.ico", "%.mp3", "%.ogg", "%.mp4", "%.webm",
      "%.epub", "%cache%", "%.ttf", "%.otf", "%.csl", "%.oil://%", "%courses%", "%.srt", "%.dll" }

    local actions = require("telescope.actions")
    local telescope = require("telescope")
    local theme = require("telescope.themes")
    local ext = require("telescope").load_extension

    --- load extensions
    ext('find_pickers')
    ext('ui-select')
    ext('possession')

    -- setup
    telescope.setup {
      defaults = {
        prompt_prefix = "   ",
        selection_caret = "  ",
        selection_strategy = "reset",
        layout_strategy = "vertical",
        path_display = function(opts, path) -- Format path as "file.txt (path\to\file\)"
          local tail = require("telescope.utils").path_tail(path)
          return string.format("%s (%s)", tail, path)
        end,

        multi_icon = " 	+ ",
        flip_columns = 150,
        file_ignore_patterns = ignore_filetypes_list,
        find_files = {
          hidden = true,
          find_command = {
            "rg",
            "--files",
            "--hidden",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case"
          },
        },
        layout_config = {
          horizontal = {
            height = 0.9,
            preview_cutoff = 0,
            prompt_position = "bottom",
            width = 0.8,
            preview_width = 0.5,
          },
          vertical = {
            height = 0.95,
            show_line = false,
            preview_height = 0.5,
            preview_cutoff = 0,
            prompt_position = "bottom",
            width = 0.8,
          },
          bottom_pane = {
            show_line = true,
            height = 25,
            preview_cutoff = 0,
            prompt_position = "top",
          },
          center = {
            show_line = true,
            height = 0.4,
            preview_cutoff = 0,
            prompt_position = "top",
            width = 0.5,
          },
          cursor = {
            show_line = false,
            height = 10,
            preview_cutoff = 40,
            width = 35,
          },

        },
        mappings = {
          i = {
            ["<CR>"] = actions.select_default,
            ["<esc>"] = actions.close,
            ["<space><space>"] = actions.close,
            ["<a-k>"] = actions.move_selection_previous,
            ["<a-j>"] = actions.move_selection_next,
            ["<a-n>"] = actions.preview_scrolling_down,
            ["<a-p>"] = actions.preview_scrolling_up,
            ["<C-h>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
            ["<C-t>"] = actions.select_tab,
            ["<C-k>"] = actions.preview_scrolling_up,
            ["<C-j>"] = actions.preview_scrolling_down,
            ["<Tab>"] = actions.toggle_selection,
            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
            ["<S-CR>"] = actions.smart_send_to_qflist + actions.open_qflist, -- Send either all entries or only selected to qflist
            ["<C- >"] = actions.which_key,
          },
          n = {
            --	    ["Q"] = actions.close,
            ["q"] = actions.close,
            ["gg"] = actions.move_to_top,
            ["G"] = actions.move_to_bottom,
            ["<CR>"] = actions.select_default,
            ["x"] = actions.select_horizontal,
            ["v"] = actions.select_vertical,
            ["t"] = actions.select_tab,
            ["<Tab>"] = actions.toggle_selection + actions.move_selection_previous,
            ["<a-CR>"] = actions.send_to_qflist + actions.open_qflist,
            ["<S-CR>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-d>"] = actions.preview_scrolling_down,
            ["<PageUp>"] = actions.results_scrolling_up,
            ["<PageDown>"] = actions.results_scrolling_down,
            ["?"] = actions.which_key,

          },
        },
      },
      extensions = {
        ["possession"] = {
          theme.get_dropdown {},
        },

        ["ui-select"] = {
          theme.get_dropdown {},
        },

      },
    }

    ---- plugin Keybinds ----
    --    vim.keymap.set('n', '<leader>q', '<cmd>Telescope macros<CR>', { desc = 'macros management'}) -- macros
    vim.keymap.set('n', '<leader>fs', '<cmd>Telescope possession list<CR>', { desc = 'session management' }) -- sessions
    vim.keymap.set('n', '<A-o>', '<cmd>Telescope find_pickers<CR>', { desc = 'command palette' })            -- meta-menu
    --    vim.keymap.set('n', '<leader>cz', telescope.extensions.chezmoi.find_files, {desc = 'chezmoi management'})
  end
}

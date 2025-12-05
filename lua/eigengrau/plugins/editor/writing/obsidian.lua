local prefix = "<leader>o"

return {
  {
    "obsidian-nvim/obsidian.nvim",
    ft = "markdown",
    cmd = "Obsidian",
    event = "BufReadPre " .. vim.fn.expand("~") .. "/Vaults/Littlewing/**.md",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    keys = {
      { prefix .. "O", "<cmd>Obsidian open<CR>", desc = "Open on App" },
      { prefix .. "f", "<cmd>Obsidian search<CR>", desc = "Grep" },
      { prefix .. "n", "<cmd>Obsidian new<CR>", desc = "New Note" },
      {
        prefix .. "N",
        "<cmd>Obsidian new_from_template<CR>",
        desc = "New Note (Template)",
      },
      {
        prefix .. "c",
        function()
          vim.ui.select(
            { "New Note", "From Template", "Daily Note", "Tomorrow" },
            { prompt = "Create note: " },
            function(choice)
              if choice == "New Note" then
                vim.cmd("Obsidian new")
              elseif choice == "From Template" then
                vim.cmd("Obsidian new_from_template")
              elseif choice == "Daily Note" then
                vim.cmd("Obsidian today")
              elseif choice == "Tomorrow" then
                vim.cmd("Obsidian tomorrow")
              end
            end
          )
        end,
        desc = "Create note (menu)",
      },
      { prefix .. "o", "<cmd>Obsidian quick_switch<CR>", desc = "Find Files" },
      { prefix .. "t", "<cmd>Obsidian tags<CR>", desc = "Tags" },
      { prefix .. "T", "<cmd>Obsidian template<CR>", desc = "Template" },
      { prefix .. "l", "<cmd>Obsidian links<CR>", desc = "Links" },
      {
        prefix .. "L",
        function()
          vim.ui.select(
            { "Link note", "Show all links", "Show backlinks" },
            { prompt = "Link action: " },
            function(choice)
              if choice == "Link note" then
                vim.cmd("Obsidian link_new")
              elseif choice == "Show all links" then
                vim.cmd("Obsidian links")
              elseif choice == "Show backlinks" then
                vim.cmd("Obsidian backlinks")
              end
            end
          )
        end,
        desc = "Link actions (menu)",
      },
      { prefix .. "r", "<cmd>Obsidian rename<CR>", desc = "Rename" },
      { prefix .. "i", "<cmd>Obsidian paste_img<CR>", desc = "Paste Image" },
      {
        prefix .. "dd",
        "<cmd>Obsidian today<CR>",
        desc = "Check Daily Note",
      },
      {
        prefix .. "dn",
        "<cmd>Obsidian tomorrow<CR>",
        desc = "Check Daily Note",
      },
      { prefix .. "s", desc = "Open Link (Split)" }, -- Defined in callbacks
      { "gs", "<cmd>Obsidian follow_link vsplit<CR>", ft = "markdown", desc = "Open link in vsplit" },

      -- Visual mode keys
      {
        prefix .. "l",
        "<cmd>Obsidian link_new<CR>",
        mode = "v",
        desc = "New Link",
      },
      {
        prefix .. "e",
        "<cmd>Obsidian extract_note<CR>",
        mode = "v",
        desc = "Extract Note",
      },
      {
        prefix .. "L",
        "<cmd>Obsidian link<CR>",
        mode = "v",
        desc = "Link",
      },
    },
    opts = {
      legacy_commands = false,
      workspaces = {
        {
          name = "Littlewing",
          path = "~/Vaults/Littlewing/",
        },
      },

      notes_subdir = "inbox",

      completion = {
        blink = true,
      },

      create_new = true,

      picker = {
        name = "telescope.nvim",
        note_mappings = {
          -- Create a new note from your query.
          new = "<C-x>",
          -- Insert a link to the selected note.
          insert_link = "<C-l>",
        },
        tag_mappings = {
          -- Add tag(s) to current note.
          tag_note = "<C-x>",
          -- Insert a tag at the current location.
          insert_tag = "<C-l>",
        },
      },

      note_id_func = function(title)
        return title
      end,

      callbacks = {
        enter_note = function(_, note)
          if not note then
            return
          end

          local function matuschak_split()
            local current_win = vim.api.nvim_get_current_win()
            local total_width = vim.o.columns

            vim.cmd("Obsidian follow_link vsplit")

            vim.defer_fn(function()
              local left_width = math.floor(total_width * 0.35)
              vim.api.nvim_win_set_width(current_win, left_width)
            end, 100)
          end

          vim.keymap.set("n", "<leader>os", matuschak_split, {
            buffer = note.bufnr,
            desc = "Open link (Matuschak style)",
          })

          vim.keymap.set("n", "gs", "<cmd>Obsidian follow_link vsplit<CR>", {
            buffer = note.bufnr,
            desc = "Open link in vertical split",
          })
        end,
      },

      new_notes_location = "notes_subdir",

      -- Frontmatter configuration (new API for obsidian.nvim 4.0+)
      frontmatter = {
        enabled = false, -- Disable automatic frontmatter management
        -- This only applies when YOU explicitly create notes via :Obsidian new
        func = function(note)
          local out = {
            aliases = note.aliases or { note.title },
            tags = note.tags or { "" },
          }
          if note.metadata and note.metadata.sorted ~= nil then
            out.sorted = note.metadata.sorted
          end
          return out
        end,
      },

      daily_notes = {
        folder = "logs",
        date_format = "%Y-%m-%d",
        alias_format = "%Y-%m-%d",
        default_tags = { "log" },
        template = "Daily log.md",
      },

      templates = {
        subdir = "templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
      },

      follow_url_func = function(url)
        vim.fn.jobstart({ "xdg-open", url })
      end,

      attachments = {
        img_folder = "resources/assets/",
      },

      image = {
        resolve = function(path, src)
          if require("obsidian.api").path_is_note(path) then
            return require("obsidian.api").resolve_image_path(src)
          end
        end,
      },

      -- UI disabled - render-markdown.nvim handles all visual rendering to avoid conflicts
      ui = {
        enable = false,
      },
    },
  },
}

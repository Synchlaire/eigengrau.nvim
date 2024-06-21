return {
    -- Telescope plugins
 'nvim-telescope/telescope.nvim',
    lazy = true,
    cmd = {"Telescope", "ObsidianQuickSwitch"},
    keys = {"<leader>ff", "<leader>cd", "<leader>fc", "<leader>q", "<leader>fh"},

    dependencies = {
        { 'nvim-telescope/telescope-frecency.nvim' },
        { '2kabhishek/nerdy.nvim' },
        { 'keyvchan/telescope-find-pickers.nvim' },
        { 'ghassan0/telescope-glyph.nvim' },
        { 'crispgm/telescope-heading.nvim', ft = "Markdown" },
        {'nvim-telescope/telescope-ui-select.nvim' },
        { 'jvgrootveld/telescope-zoxide' }
    },
    config = function()
        -- set locals for conciseness

        local ignore_filetypes_list = { "venv", "__pycache__", "%.jpeg",
            "%.jpg", "%.png", "%.webp", "%.pdf",  "%.ico", "%.mp3", "%.mp4",
            "%.webm", "%.epub", "%cache%", "%.ttf" }

        local telescope = require("telescope")
        local utils = require("telescope").utils
        local builtin = require('telescope.builtin')
        local actions = require("telescope.actions")
        local ext = require("telescope").load_extension
        local theme = require("telescope.themes")

--- load extensions
        ext('macros')
        ext('frecency')
        ext('nerdy')
        ext('glyph')
        ext('find_pickers')
        ext('heading')
        ext('zoxide')
        ext('ui-select')
        ext('possession')


        -- setup
        telescope.setup {
            defaults = {
                prompt_prefix = "  ",
                selection_caret = " 󰼛",
                multi_icon = "",
                file_ignore_patterns = ignore_filetypes_list,
                mappings = {
                    i = {
                        ["<a-k>"] = actions.move_selection_previous,
                        ["<a-j>"] = actions.move_selection_next,
                        ["jk"] = actions.close,
                        ["kj"] = actions.close,
                        ["<a-n>"] = actions.preview_scrolling_down,
                        ["<a-p>"] = actions.preview_scrolling_up,
                        ["<S-cr>"] = actions.file_vsplit,
                    },
            --        n = {
            --            ["a-k"] = actions.close,
            --            ["a-j"] = actions.close,
            --        },
                },
            },
            extensions = {
                ["ui-select"] = {
            theme.get_dropdown {},
        },
                [ "zoxide" ] = {
                    prompt_title = "[ Zoxide ]",
                    -- Zoxide list command with score
                    list_command = "zoxide query -ls",
                    mappings = {
                        default = {
                            action = function(selection)
                                vim.cmd.edit(selection.path)
                            end,
                            after_action = function(selection)
                                print("Directory changed to " .. selection.path)
                            end
                        },
                        ["<S-CR>"] = { action = require("telescope._extensions.zoxide.utils").create_basic_command("vsplit") },
                        ["<cr>"] = { action = require("telescope._extensions.zoxide.utils").create_basic_command("edit") },
                        ["<C-b>"] = {
                            keepinsert = true,
                            action = function(selection)
                                builtin.file_browser({ cwd = selection.path })
                            end
                        },
                    ["<C-f>"] = {
                            keepinsert = true,
                            action = function(selection)
                                builtin.find_files({ cwd = selection.path })
                            end
                        },
                    ["<C-t>"] = {
                            action = function(selection)
                                vim.cmd.tcd(selection.path)
                            end
                        },
                    },
                },

                frecency = {
                    auto_validate = true,
                    matcher = "default",
                    db_safe_mode = false,
                    show_filter_column = { "LSP", "CWD", "FOO" },
                    show_unindexed = true,
                    show_scores = true,
                    ignore_patterns = { "*.git/*", "*/tmp/*", "*cache*", "*.pdf" },
                    disable_devicons = false,
                    -- path_display = {"shorten"},
                },
            },
        }

        --- Keybinds
        vim.keymap.set('n', '<leader>fd', builtin.fd, { desc = 'Find files across system'})
        vim.keymap.set('n', '<leader>fd', builtin.fd, { desc = 'Find files across system'})
        vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'live grep'})
        vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'help tags'})
        vim.keymap.set('n', '<leader>fc', builtin.colorscheme, { desc = 'change colorscheme'})

        -- neocomposer macros
        vim.keymap.set('n', '<leader>q', '<cmd>Telescope macros<CR>', { desc = 'macros management'})

        -- frecency open
        vim.keymap.set('n', '<leader>ff', '<cmd>Telescope frecency<CR>', {desc = 'search files globally'})
        -- zoxide
        vim.keymap.set('n', '<leader>cd', '<cmd>Telescope zoxide list<CR>', {desc = 'search directories'})

        -- session management
        vim.keymap.set('n', '<leader>fs', '<cmd>Telescope possession list<CR>', { desc = 'session management'})

        --- meta-menu
        vim.keymap.set('n', '<A-o>', '<cmd>Telescope find_pickers<CR>', {desc = 'telescope menu'})
    end
}


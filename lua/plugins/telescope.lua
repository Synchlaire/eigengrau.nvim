--- settings

require 'telescope'.setup {
    defaults = {
--     prompt_prefix = "󰼛 ",
     selection_caret = "  ",
},
  extensions = {
      frecency = {
        auto_validate = true,
        db_safe_mode = true,
        show_filter_column = { "LSP", "CWD", "FOO" },
        show_unindexed = true,
        show_scores = true,
        ignore_patterns = { "*.git/*", "*/tmp/*" },
               disable_devicons = false,
--        path_display = {"shorten"},

    },
  },
}

--- Keybinds

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'live grep'})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'help tags'})
vim.keymap.set('n', '<leader>fc', builtin.colorscheme, { desc = 'change colorscheme'})


-- neocomposer macros

require('telescope').load_extension('macros')
vim.keymap.set('n', '<leader>q', '<cmd>Telescope macros<CR>' , { desc = 'macros management'})

-- smart open
require("telescope").load_extension('frecency')
vim.keymap.set('n', '<leader>ff', '<cmd>Telescope frecency<CR>', {desc = 'search files globally'})
vim.keymap.set('n', '<leader>fF', '<cmd>Telescope frecency workspace=CWD<CR>', {desc = 'search files in current working dir'})


--- nerd icons
require('telescope').load_extension('nerdy')
require('telescope').load_extension('glyph')


--- meta-menu
require('telescope').load_extension('find_pickers')


vim.keymap.set('n', '<A-o>', '<cmd>Telescope find_pickers<CR>', {desc = 'telescope menu'})




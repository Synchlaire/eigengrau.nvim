return {
   'nvim-lualine/lualine.nvim', dependencies = {
    'meuter/lualine-so-fancy.nvim',
    'nativerv/lualine-wal.nvim',
  }, event = {"BufReadPre", "BufNewFile", "InsertEnter"},
config = function ()
-- locals
local function SessionName()
    return require('possession.session').get_session_name or ''
end

require('transparent').clear_prefix('lualine')
require('lualine').setup {
    options = {
        globalstatus = false,
        icons_enabled = true,
        theme = 'auto',
        draw_empty = true,
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
        disabled_filetypes = {
            statusline = {"alpha"},
            winbar = {},

        },
        ignore_focus = {},
        always_divide_middle = false,
        refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
        }
    },
    sections = {
        lualine_a = { 'mode', 'fancy_macro' },
        lualine_b = { 'branch', 'fancy_diagnostics', { 'SessionName'} },
        lualine_c = { '%=',
            { 'buffers',
            show_filename_only = true,
            hide_filename_extension = true,
            show_modified_status = true,
            mode = 2
        },
        },
        lualine_x = {'fancy_cwd', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = { 'toggleterm' }
}
    end

}


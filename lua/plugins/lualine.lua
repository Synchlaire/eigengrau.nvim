-- Status bar
require('lualine').setup {
    options = {
        globalstatus = true,
        icons_enabled = true,
        theme = 'auto',
        draw_empty = false,
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
        disabled_filetypes = {
            statusline = {},
            winbar = {},

        },
        ignore_focus = {},
        always_divide_middle = true,
        refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
        }
    },
    sections = {
        lualine_a = { 'mode', 'fancy_macro' },
        lualine_b = { 'fancy_branch', 'fancy_diff', 'fancy_diagnostics' },
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

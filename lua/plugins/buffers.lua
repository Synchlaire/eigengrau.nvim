require 'jabs'.setup {
    -- Options for the main window
    position = {'center', 'bottom'}, 
    relative = 'win', -- win, editor, cursor. Default win
    clip_popup_size = true, -- clips the popup size to the win (or editor) size. Default true

    width = 60, -- default 50
    height = 10, -- default 10
    border = 'single', -- none, single, double, rounded, solid, shadow, (or an array or chars). Default shadow

    offset = { -- window position offset
        top = 0, -- default 0
        bottom = 0, -- default 0
        left = 0, -- default 0
        right = 0, -- default 0
    },

    sort_mru = true, -- Sort buffers by most recently used (true or false). Default false
    split_filename = false, -- Split filename into separate components for name and path. Default false
    split_filename_path_width = 0, -- If split_filename is true, how wide the column for the path is supposed to be, Default 0 (don't show path)

    -- Options for preview window
    preview_position = 'top', -- top, bottom, left, right. Default top
    preview = {
        width = 70, -- default 70
        height = 50, -- default 30
        border = 'double', -- none, single, double, rounded, solid, shadow, (or an array or chars). Default double
    },

    -- Default highlights (must be a valid :highlight)
    highlight = {
        current = "PMenuSel", -- default StatusLine
        hidden = "ModeMsg", -- default ModeMsg
        split = "StatusLine", -- default StatusLine
        alternate = "WarningMsg" -- default WarningMsg
    },

    -- Default symbols
--    symbols = {
--        current = "C", -- default 
--        split = "S", -- default 
--        alternate = "A", -- default 
--        hidden = "H", -- default ﬘
--        locked = "L", -- default 
--        ro = "R", -- default 
--        edited = "E", -- default 
--        terminal = "T", -- default 
--        default_file = "D", -- Filetype icon if not present in nvim-web-devicons. Default 
--        terminal_symbol = ">_" -- Filetype icon for a terminal split. Default 
--    },

    -- Keymaps
    keymap = {
        close = "d", -- Close buffer. Default D
        jump = "<space>", -- Jump to buffer. Default <cr>
        v_split = "s", -- Vertically split buffer. Default v
        preview = "p", -- Open buffer preview. Default P
    },

    -- Whether to use nvim-web-devicons next to filenames
    use_devicons = true -- true or false. Default true
}

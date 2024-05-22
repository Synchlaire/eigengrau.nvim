require("sidebar-nvim").setup({
    disable_default_keybindings = 0,
    bindings = nil,
    open = false,
    side = "left",
    initial_width = 35,
    hide_statusline = false,
    update_interval = 1000,
    sections = { "datetime" , "buffers", "diagnostics"},
    section_separator = {"", ""},
    section_title_separator = {""},


    -- sections
    containers = { attach_shell = "/bin/zsh", show_all = true, interval = 5000, },
    datetime = { format = "%a %b %d, %H:%M", clocks = { { name = "local" } } },
    todos = { ignored_paths = { "~" } },
    buffers = {
            ignore_not_loaded = true, -- whether to ignore not loaded buffers
            show_numbers = false,
            sorting = "id"
        }
})

return {
    'goolord/alpha-nvim',
    event = "VimEnter",
    config = function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")

        -- set header
        local ouroboros = {
            '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⣀⣀⣀⣀⣄⣀⠀⠀⠀⠀⠀⠀',
            '⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣴⡶⢿⣟⡛⣿⢉⣿⠛⢿⣯⡈⠙⣿⣦⡀⠀⠀⠀',
            '⠀⠀⠀⠀⠀⠀⣠⡾⠻⣧⣬⣿⣿⣿⣿⣿⡟⠉⣠⣾⣿⠿⠿⠿⢿⣿⣦⠀⠀',
            '⠀⠀⠀⠀⣠⣾⡋⣻⣾⣿⣿⣿⠿⠟⠛⠛⠛⠀⢻⣿⡇⢀⣴⡶⡄⠈⠛⠀⠀',
            '⠀⠀⠀⣸⣿⣉⣿⣿⣿⡿⠋⠀⠀⠀⠀⠀⠀⠀⠈⢿⣇⠈⢿⣤⡿⣦⠀⠀⠀',
            '⠀⠀⢰⣿⣉⣿⣿⣿⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠦⠀⢻⣦⠾⣆⠀⠀',
            '⠀⠀⣾⣏⣿⣿⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⡶⢾⡀⠀',
            '⠀⠀⣿⠉⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣧⣼⡇⠀',
            '⠀⠀⣿⡛⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⣧⣼⡇⠀',
            '⠀⠀⠸⡿⢻⣿⣿⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣼⣿⣥⣽⠁⠀',
            '⠀⠀⠀⢻⡟⢙⣿⣿⣿⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⣿⣧⣸⡏⠀⠀',
            '⠀⠀⠀⠀⠻⣿⡋⣻⣿⣿⣿⣦⣤⣀⣀⣀⣀⣀⣠⣴⣿⣿⢿⣥⣼⠟⠀⠀⠀',
            '⠀⠀⠀⠀⠀⠈⠻⣯⣤⣿⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⠛⣷⣴⡿⠋⠀⠀⠀⠀',
            '⠀⠀⠀⠀⠀⠀⠀⠈⠙⠛⠾⣧⣼⣟⣉⣿⣉⣻⣧⡿⠟⠋⠁⠀⠀⠀⠀⠀⠀',
            '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠉⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
        }

        dashboard.section.header.val = ouroboros
        dashboard.section.header.opts = {
            type = "text",
            position = "center",
--            hl = "question",
            wrap = "overflow"
        }
        -- menu config

        dashboard.section.buttons.val = {
            dashboard.button("n", "  New file", "<cmd>ene <BAR> startinsert <CR>"),
            dashboard.button("ff", "  Find file", "<cmd>cd $HOME | Telescope find_files<CR>"),
            dashboard.button("fd", " open folder", "<cmd>cd $HOME | Telescope zoxide list<CR>"),
            dashboard.button("fr", "  Recent", "<cmd>Telescope frecency<CR>"),
            dashboard.button("o", "  Codex", "<cmd>ObsidianQuickSwitch<CR>"),
            dashboard.button("lz", "󰂖  Lazy", ":Lazy<CR>"),
            dashboard.button("c", "  Config", "<cmd>cd ~/.config/nvim/ | e . | pwd<CR>"),
            dashboard.button("m", "󱌣  Mason", ":Mason<CR>"),
            dashboard.button("qq", "  Quit NVIM", "<cmd>qa<CR>"),
        }

        dashboard.section.footer.val = "Total plugins: " .. require("lazy").stats().count

        -- main configs

        -- Disable folding on alpha buffer
        vim.cmd([[ autocmd FileType alpha setlocal nofoldenable ]])

        --  Hide tabline and statusline on startup screen

        vim.api.nvim_create_augroup("alpha_tabline", { clear = true })

        vim.api.nvim_create_autocmd("FileType", {
            group = "alpha_tabline",
            pattern = "alpha",
            command = "set showtabline=0 laststatus=0 noruler",
        })

        vim.api.nvim_create_autocmd("FileType", {
            group = "alpha_tabline",
            pattern = "alpha",
            callback = function()
                vim.api.nvim_create_autocmd("BufUnload", {
                    group = "alpha_tabline",
                    buffer = 0,
                    command = "set showtabline=0 ruler laststatus=3",
                })
            end,
        })

        -- Send config to alpha
        alpha.setup(dashboard.opts)
    end
}

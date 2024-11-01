return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  enabled = true,
  init = false,
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    -- Set header
    local ghost = {
      " ⠀⠀⠀⠀⠀⠀⢀⣤⣶⣶⣖⣦⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀",
      " ⠀⠀⠀⠀⢀⣾⡟⣉⣽⣿⢿⡿⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀",
      " ⠀⠀⠀⢠⣿⣿⣿⡗⠋⠙⡿⣷⢌⣿⣿⠀⠀⠀⠀⠀⠀⠀",
      " ⣷⣄⣀⣿⣿⣿⣿⣷⣦⣤⣾⣿⣿⣿⡿⠀⠀⠀⠀⠀⠀⠀",
      " ⠈⠙⠛⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⡀⠀⢀⠀⠀⠀⠀",
      " ⠀⠀⠀⠸⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠻⠿⠿⠋⠀⠀⠀⠀",
      " ⠀⠀⠀⠀⠹⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀",
      " ⠀⠀⠀⠀⠀⠈⢿⣿⣿⣿⣿⣿⣿⣇⠀⠀⠀⠀⠀⠀⠀⡄",
      " ⠀⠀⠀⠀⠀⠀⠀⠙⢿⣿⣿⣿⣿⣿⣆⠀⠀⠀⠀⢀⡾⠀",
      " ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣿⣿⣿⣿⣷⣶⣴⣾⠏⠀⠀",
      " ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠛⠛⠛⠋⠁⠀⠀⠀",
    }
    local ouroboros = {
      "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⣀⣀⣀⣀⣄⣀⠀⠀⠀⠀⠀⠀",
      "⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣴⡶⢿⣟⡛⣿⢉⣿⠛⢿⣯⡈⠙⣿⣦⡀⠀⠀⠀",
      "⠀⠀⠀⠀⠀⠀⣠⡾⠻⣧⣬⣿⣿⣿⣿⣿⡟⠉⣠⣾⣿⠿⠿⠿⢿⣿⣦⠀⠀",
      "⠀⠀⠀⠀⣠⣾⡋⣻⣾⣿⣿⣿⠿⠟⠛⠛⠛⠀⢻⣿⡇⢀⣴⡶⡄⠈⠛⠀⠀",
      "⠀⠀⠀⣸⣿⣉⣿⣿⣿⡿⠋⠀⠀⠀⠀⠀⠀⠀⠈⢿⣇⠈⢿⣤⡿⣦⠀⠀⠀",
      "⠀⠀⢰⣿⣉⣿⣿⣿⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠦⠀⢻⣦⠾⣆⠀⠀",
      "⠀⠀⣾⣏⣿⣿⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⡶⢾⡀⠀",
      "⠀⠀⣿⠉⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣧⣼⡇⠀",
      "⠀⠀⣿⡛⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⣧⣼⡇⠀",
      "⠀⠀⠸⡿⢻⣿⣿⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣼⣿⣥⣽⠁⠀",
      "⠀⠀⠀⢻⡟⢙⣿⣿⣿⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⣿⣧⣸⡏⠀⠀",
      "⠀⠀⠀⠀⠻⣿⡋⣻⣿⣿⣿⣦⣤⣀⣀⣀⣀⣀⣠⣴⣿⣿⢿⣥⣼⠟⠀⠀⠀",
      "⠀⠀⠀⠀⠀⠈⠻⣯⣤⣿⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⠛⣷⣴⡿⠋⠀⠀⠀⠀",
      "⠀⠀⠀⠀⠀⠀⠀⠈⠙⠛⠾⣧⣼⣟⣉⣿⣉⣻⣧⡿⠟⠋⠁⠀⠀⠀⠀⠀⠀",
      "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠉⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
    }
local bruh = {
      "  ⣇⣿⠘⣿⣿⣿⡿⡿⣟⣟⢟⢟⢝⠵⡝⣿⡿⢂⣼⣿⣷⣌⠩⡫⡻⣝⠹⢿⣿⣷  ",
      "  ⡆⣿⣆⠱⣝⡵⣝⢅⠙⣿⢕⢕⢕⢕⢝⣥⢒⠅⣿⣿⣿⡿⣳⣌⠪⡪⣡⢑⢝⣇  ",
      "  ⡆⣿⣿⣦⠹⣳⣳⣕⢅⠈⢗⢕⢕⢕⢕⢕⢈⢆⠟⠋⠉⠁⠉⠉⠁⠈⠼⢐⢕⢽  ",
      "  ⡗⢰⣶⣶⣦⣝⢝⢕⢕⠅⡆⢕⢕⢕⢕⢕⣴⠏⣠⡶⠛⡉⡉⡛⢶⣦⡀⠐⣕⢕  ",
      "  ⡝⡄⢻⢟⣿⣿⣷⣕⣕⣅⣿⣔⣕⣵⣵⣿⣿⢠⣿⢠⣮⡈⣌⠨⠅⠹⣷⡀⢱⢕  ",
      "  ⡝⡵⠟⠈⢀⣀⣀⡀⠉⢿⣿⣿⣿⣿⣿⣿⣿⣼⣿⢈⡋⠴⢿⡟⣡⡇⣿⡇⡀⢕  ",
      "  ⡝⠁⣠⣾⠟⡉⡉⡉⠻⣦⣻⣿⣿⣿⣿⣿⣿⣿⣿⣧⠸⣿⣦⣥⣿⡇⡿⣰⢗⢄  ",
      "  ⠁⢰⣿⡏⣴⣌⠈⣌⠡⠈⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣬⣉⣉⣁⣄⢖⢕⢕⢕  ",
      "  ⡀⢻⣿⡇⢙⠁⠴⢿⡟⣡⡆⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣵⣵⣿  ",
      "  ⡻⣄⣻⣿⣌⠘⢿⣷⣥⣿⠇⣿⣿⣿⣿⣿⣿⠛⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿  ",
      "  ⣷⢄⠻⣿⣟⠿⠦⠍⠉⣡⣾⣿⣿⣿⣿⣿⣿⢸⣿⣦⠙⣿⣿⣿⣿⣿⣿⣿⣿⠟  ",
      "  ⡕⡑⣑⣈⣻⢗⢟⢞⢝⣻⣿⣿⣿⣿⣿⣿⣿⠸⣿⠿⠃⣿⣿⣿⣿⣿⣿⡿⠁⣠  ",
      "  ⡝⡵⡈⢟⢕⢕⢕⢕⣵⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣶⣿⣿⣿⣿⣿⠿⠋⣀⣈⠙  ",
      "  ⡝⡵⡕⡀⠑⠳⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠛⢉⡠⡲⡫⡪⡪⡣  ",

    }




    dashboard.section.header.val = ghost
    dashboard.section.header.opts = {
      type = "text",
      position = "center",
      wrap = "overflow",
    }


    --- SECTIONS

    -- Buttons
    dashboard.section.buttons.val = {
    dashboard.button( "s"  , "  Sessions      " , "<cmd>Telescope possession list theme=dropdown initial_mode=normal <CR> " ),
    dashboard.button( "h"  , "  Home          " , "<cmd>cd $HOME | e . | pwd<CR>" ),
    dashboard.button( "n"  , "  New file      " , "<cmd>ene <BAR> startinsert <CR>" ),
    dashboard.button( "c"  , "  Config        " , "<cmd>cd ~/.config/nvim/|e . | pwd<CR>" ),
    dashboard.button( "o"  , "  Codex         " , "<cmd>cd ~/Vaults/|e . | pwd<CR>" ),
    dashboard.button( "p"  , "󱅄  Projects      " , "<cmd>ProjectExplorer<CR>" ),
    dashboard.button( "l"  , "󱈼  Lazy Plugins  " , "<cmd>Lazy<CR>" ),
    dashboard.button( "ff" , "  Find file     " , "<cmd>cd $HOME | Telescope fd<CR>" ),
    dashboard.button( "fr" , "  Recent files  " , "<cmd>Telescope oldfiles<CR>" ),
    dashboard.button( "qq" , "  Quit NVIM     " , "<cmd>qa<CR>" ),

    }

    -- Footer
        vim.api.nvim_create_autocmd("User", {
            pattern = "LazyVimStarted",
            callback = function()
                local v = vim.version()
                local dev = ""
                if v.prerelease == "dev" then
                    dev = "-dev+" .. v.build
                else
                    dev = ""
                end
                local version = v.major .. "." .. v.minor .. "." .. v.patch .. dev
                local stats = require("lazy").stats()
                local plugins_count = stats.loaded .. "/" .. stats.count
                local ms = math.floor(stats.startuptime + 0.5)
                local time = vim.fn.strftime("%H:%M:%S")
                local date = vim.fn.strftime("%d.%m.%Y")
                local line1 = "鈴" .. plugins_count .. " bloat loaded in " .. ms .. "ms"
                local line2 = "󰃭 " .. date .. "  " .. time
                local line3 = " " .. version

                local line1_width = vim.fn.strdisplaywidth(line1)
                local line2Padded = string.rep(" ", (line1_width - vim.fn.strdisplaywidth(line2)) / 2) .. line2
                local line3Padded = string.rep(" ", (line1_width - vim.fn.strdisplaywidth(line3)) / 2) .. line3

                dashboard.section.footer.val = {
                    line1,
--                    line2Padded,
--                    line3Padded,
                }
                pcall(vim.cmd.AlphaRedraw)
            end,
    })

    -- Disable folding on alpha buffer
    vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])

    -- Hide tabline and statusline on startup screen
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
	  command = "set showtabline=1 ruler laststatus=3",
	})
      end,
    })

    -- Setup alpha with the dashboard
    alpha.setup({
      layout = {
	{ type = "padding", val = 5 },
	dashboard.section.header,
	{ type = "padding", val = 5 },
	dashboard.section.buttons,
	{ type = "padding", val = 5 },
	dashboard.section.footer,
	{ type = "padding", val = 1 },
      },

      opts = {
	noautocmd = false, --better integration with plugins
	margin = 35,
	shrink_margin = true,
--	wrap = "overflow",

      },

    })
  end,
}

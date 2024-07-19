return {
    "kdheepak/lazygit.nvim",
    keys = { "<leader>gl" },
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        local lazygit = require("lazygit")

        local opts = { noremap = true, silent = true }
        vim.keymap.set("n", "<leader>gl", lazygit.lazygit, opts)
    end,
}

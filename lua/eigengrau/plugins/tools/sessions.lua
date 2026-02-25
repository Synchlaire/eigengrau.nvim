return {
  {
    "DrKJeff16/project.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    lazy = true,
    cmd = {
      "Project", "ProjectAdd", "ProjectDelete", "ProjectHistory",
      "ProjectRoot", "ProjectSession"
    },
    keys = {
      { "<leader>sp", "<cmd>Project<CR>",        desc = "Projects" },
      { "<leader>ss", "<cmd>ProjectSession<CR>", desc = "Sessions" },
      { "<leader>sa", "<cmd>ProjectAdd<CR>",     desc = "Add project" },
      { "<leader>sd", "<cmd>ProjectDelete<CR>",  desc = "Delete project" },
      { "<leader>sr", "<cmd>ProjectRoot<CR>",    desc = "Show project root" },
    },
    opts = {
      manual_mode = false,
      silent_chdir = true,
      scope_chdir = "global",
      snacks = {
        enabled = true,
        opts = {
          sort = "newest",
          title = "Projects",
          layout = "select",
        },
      },
    },
  },
}

return {
  "Rics-Dev/project-explorer.nvim",
  lazy = true,
  cmd = "ProjectExplorer",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  opts = {
    paths = { "~/projects" }, --custom path set by user
    newProjectPath = "~/projects/", --custom path for new projects
     file_explorer = function(dir)
       require("oil").open(dir)
     end,
  },
  config = function(_, opts)
    require("project_explorer").setup(opts)
  end,
  keys = {
    { "<leader>fp", "<cmd>ProjectExplorer<cr>", desc = "Project Explorer" },
  },
}

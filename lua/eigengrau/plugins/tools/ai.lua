return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    -- "nvim-telescope/telescope.nvim", -- Optional: for using Telescope in slash commands
    { "stevearc/dressing.nvim", opts = {} }, -- Optional: improves the UI
  },
  cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
  keys = {
    { "<leader>ca", "<cmd>CodeCompanionActions<cr>", desc = "AI Actions", mode = { "n", "v" } },
    { "<leader>cc", "<cmd>CodeCompanionChat Toggle<cr>", desc = "AI Chat Toggle", mode = { "n", "v" } },
    { "<leader>cn", "<cmd>CodeCompanionChat<cr>", desc = "AI Chat New", mode = { "n", "v" } },
    { "ga", "<cmd>CodeCompanionChat Add<cr>", desc = "Add to AI Chat", mode = "v" },
  },
  config = function()
    require("codecompanion").setup({
      strategies = {
        chat = {
          adapter = "gemini",
          slash_commands = {
            ["tasks"] = {
              description = "Extract tasks",
              prompts = {
                {
                  role = "system",
                  content = "You are an expert project manager. Extract all actionable tasks, TODOs, and requirements from the user's input.",
                },
                {
                  role = "user",
                  content = "Analyze the following text and extract all actionable tasks into a markdown checklist format. Be specific and concise.",
                },
              },
            },
            ["proofread"] = {
              description = "Proofread text",
              prompts = {
                {
                  role = "system",
                  content = "You are an expert editor. Proofread the user's text for academic clarity, tone, and grammar. Do not change the underlying meaning.",
                },
                {
                  role = "user",
                  content = "Proofread the following text. Provide a corrected version and a brief list of changes made.",
                },
              },
            },
          },
        },
        inline = {
          adapter = "gemini",
        },
        agent = {
          adapter = "gemini",
        },
      },
      adapters = {
        gemini = function()
          return require("codecompanion.adapters").extend("gemini", {
            env = {
              api_key = vim.env.GEMINI_API_KEY,
            },
            schema = {
              model = {
                default = "gemini-1.5-flash",
              },
            },
          })
        end,
        -- openai = function()
        --   return require("codecompanion.adapters").extend("openai", {
        --     env = {
        --       api_key = "YOUR_OPENAI_API_KEY",
        --     },
        --   })
        -- end,
        -- anthropic = function()
        --   return require("codecompanion.adapters").extend("anthropic", {
        --     env = {
        --       api_key = "YOUR_ANTHROPIC_API_KEY",
        --     },
        --   })
        -- end,
      },
      display = {
        chat = {
          window = {
            layout = "vertical",
            width = 0.3,
          },
        },
        diff = {
          provider = "default",
        },
      },
    })
  end,
}

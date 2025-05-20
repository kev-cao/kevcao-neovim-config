--- @module 'plugins.ai'
--- All AI related plugins

local func = require("util.func")
local keymaps = require("config.keymaps")

return {
  {
    "joshuavial/aider.nvim",
    cond = function()
      return func.check_global_var("use_aider", true, true)
    end,
    opts = {
      -- your configuration comes here
      -- if you don't want to use the default settings
      auto_manage_context = true, -- automatically manage buffer context
      default_bindings = true,    -- use default <leader>A keybindings
      debug = false,              -- enable debug logging
    },
    keys = keymaps.aider.keys,
  },
  {
    "zbirenbaum/copilot.lua",
    event = { "InsertEnter" },
    cond = function()
      return func.check_global_var("use_copilot", true, true)
    end,
    keys = keymaps.copilot.keys,
    opts = {
      copilot_node_command = "/Users/kevin/.nodenv/versions/23.9.0/bin/node",
      panel = {
        enabled = false,
      },
      suggestion = {
        enabled = true,
        auto_trigger = true,
      },
    },
    config = function(_, opts)
      require("copilot").setup(opts)
    end,
  },
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      -- curl must be installed
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      strategies = {
        chat = {
          adapter = "copilot",
          slash_commands = {
            ["file"] = {
              opts = {
                provider = "fzf_lua",
              },
            },
          },
        },
        inline = {
          adapter = "copilot",
        },
      },
    },
    keys = keymaps.code_companion.keys,
    config = function(_, opts)
      require("codecompanion").setup(opts)
    end,
    cond = function()
      return func.check_global_var("use_codecompanion", true, true)
    end,
  },
}

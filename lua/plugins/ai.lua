--- @module 'plugins.ai'
--- All AI related plugins

local func = require("util.func")
local keymaps = require("config.keymaps")

return {
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
    "greggh/claude-code.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim", -- Required for git operations
    },
    keys = keymaps.claude.keys,
    opts = {
      command = "NODENV_VERSION=23.9.0 claude",
      window = {
        split_ratio = 0.3,
        position = "vertical botright",
      }
    },
    cond = function()
      return func.check_global_var("use_claude", true, true)
    end,
    config = function(_, opts)
      require("claude-code").setup(opts)
    end
  },
}

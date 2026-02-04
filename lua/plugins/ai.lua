--- @module 'plugins.ai'
--- All AI related plugins

local keymaps = require("config.keymaps")
local config  = require("util.config")

return {
  {
    "zbirenbaum/copilot.lua",
    event = { "InsertEnter" },
    cond = function()
      return config.plugin_enabled("copilot")
    end,
    keys = keymaps.copilot.keys,
    opts = {
      copilot_node_command = config.get_local("node_path", "/usr/local/bin/node"),
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
      return config.get_local("ai_assistant", nil) == "claude" and
        config.plugin_enabled("claude-code")
    end,
    config = function(_, opts)
      require("claude-code").setup(opts)
    end
  },
  {
    "NickvanDyke/opencode.nvim",
    dependencies = {
      { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
    },
    keys = keymaps.opencode.keys,
    cond = function()
      return config.get_local("ai_assistant", nil) == "opencode" and
        config.plugin_enabled("opencode")
    end,
    init = function()
      vim.o.autoread = true
    end,
  }
}

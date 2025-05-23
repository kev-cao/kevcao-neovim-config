--- @module 'plugins.debugger'
--- Debugger related plugins

local func = require("util.func")
local keymaps = require("config.keymaps")

return {
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    keys = keymaps.dap.keys,
    config = function()
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup()
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
    end,
    cond = function()
      return func.check_global_var("use_dap_ui", true, true)
    end,
  },
  {
    "leoluz/nvim-dap-go",
    dependencies = {
      -- Also requires delve installed.
      "rcarriga/nvim-dap-ui",
    },
    config = function()
      require("dap-go").setup()
    end,
    ft = "go",
    keys = keymaps.dapgo.keys,
    cond = function()
      return func.check_global_var("use_dap_ui", true, true)
    end,
  },
  {
    "mfussenegger/nvim-dap",
    cond = function()
      return func.check_global_var("use_dap_ui", true, true)
    end,
    config = function()
      local dap = require("dap")
      dap.configurations.go = {
        {
          type = "go",
          request = "attach",
          name = "Attach to CRDB process",
          mode = "local",
          processId = require("dap.utils").pick_process,
          substitutePath = {
            {
              from = "/Users/kevin/go/src/github.com/cockroachdb/cockroach",
              to = "",
            },
          },
        },
      }
    end,
  },
}

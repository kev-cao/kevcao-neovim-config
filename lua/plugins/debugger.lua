--- @module 'plugins.debugger'
--- Debugger related plugins

local func = require("util.func")
local keymaps = require("config.keymaps")

return {
  {
    "igorlfs/nvim-dap-view",
    keys = keymaps.dap.keys,
    opts = {
      winbar = {
        sections = {
          "watches", "scopes", "exceptions", "breakpoints", "threads", "repl", "console",
        },
        default_section = "scopes",
        controls = {
          enabled = true,
        }
      },
    },
    config = function(_, opts)
      local dap, dapview = require("dap"), require("dap-view")
      dapview.setup(opts)
      dap.listeners.before.attach.dapui_config = function()
        dapview.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapview.open()
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
      "igorlfs/nvim-dap-view",
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
    dependencies = {
      "igorlfs/nvim-dap-view",
    },
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

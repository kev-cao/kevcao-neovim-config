--- @module 'plugins.debugger'
--- Debugger related plugins

local config = require("util.config")
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
        base_sections = {
          scopes = {
            keymap = "A",
            label = "Scopes",
          },
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
      return not config.is_plugin_disabled("dap-ui")
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
      return not config.is_plugin_disabled("dap-ui")
    end,
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "igorlfs/nvim-dap-view",
    },
    init = function()
      vim.o.switchbuf = "useopen,uselast"
    end,
    cond = function()
      return not config.is_plugin_disabled("dap-ui")
    end,
    config = function()
      local dap = require("dap")
      dap.configurations.go = {
        {
          type = "go",
          request = "attach",
          name = "Attach to process",
          mode = "local",
          processId = require("dap.utils").pick_process,
          substitutePath = {
            {
              from = "/Users/kevin/go/src/github.com/cockroachdb/cockroach",
              to = "",
            },
          },
        },
        {
          type = "go",
          name = "Attach remote",
          mode = "remote",
          request = "attach",
          port = 2345,
          host = "127.0.0.1",
        },
      }

      dap.adapters.codelldb = {
        type = "server",
        host = "127.0.0.1",
        port = "${port}",
        executable = {
          command = "/Users/kevin/.local/share/nvim/mason/bin/codelldb",
          args = { "--port", "${port}" },
        },
      }
      dap.configurations.rust = {
        {
          name = "Launch",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }
    end,
  },
}

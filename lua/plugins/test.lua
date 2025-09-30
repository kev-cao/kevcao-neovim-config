--- @module 'plugins.test'
--- Test related plugins

local func = require("util.func")
local keymaps = require("config.keymaps")

return {
  {
    "klen/nvim-test",
    event = { "VeryLazy" },
    keys = keymaps.test.keys,
    opts = {
      termOpts = {
        direction = "horizontal",
        height = 12,
        go_back = true,
      },
    },
    config = function(_, opts)
      require("nvim-test").setup(opts)
    end,
    cond = function()
      return func.check_global_var("use_nvim_test", true, true)
    end,
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "fredrikaverpil/neotest-golang",
    },
    cond = function()
      return func.check_global_var("use_neotest", true, true)
    end,
    keys = keymaps.neotest.keys,
    opts = {
      adapters = {
        ["neotest-golang"] = {
          go_test_args = {"-v"},
          warn_test_name_dupes = false,
        },
      },
      discovery = {
        enabled = false,
      },
      output_panel = {
        open = "botright split | resize 12"
      },
    },
    config = function(_, opts)
      local adapters = {}
      for name, adapterOpts in pairs(opts.adapters) do
        table.insert(adapters, require(name)(adapterOpts))
      end
      opts.adapters = adapters
      require("neotest").setup(opts)
    end
  }
}

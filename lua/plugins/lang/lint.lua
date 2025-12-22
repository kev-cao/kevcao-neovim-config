--- @module "plugins.lang.lint"
--- This module configures linters for Neovim.

local func = require("util.func")
local plugins = require("util.plugins")

return {
  {
    "mfussenegger/nvim-lint",
    branch = "master",
    lazy = true,
    event = { "BufReadPre", "BufNewFile" },
    cond = function()
      return func.check_global_var("use_linter", true, true)
    end,
    opts = function()
      local opts = {}
      local lsp_specs = plugins.get_lsp_specs()
      for _, spec in pairs(lsp_specs) do
        if spec.linter then
          for _, ft in ipairs(spec.ft or {}) do
            opts[ft] = spec.linter
          end
        end
      end
      return opts
    end,
    config = function(_, opts)
      local lint = require("lint")
      lint.linters_by_ft = opts
    end,
  },
}

--- @module "plugins.lang.lint"
--- This module configures linters for Neovim.

local config = require("util.config")
local plugins = require("util.plugins")

return {
  {
    "mfussenegger/nvim-lint",
    branch = "master",
    lazy = true,
    event = { "BufReadPre", "BufNewFile" },
    cond = function()
      return config.plugin_enabled("nvim-lint")
    end,
    opts = function()
      local opts = {}
      local lsp_specs = plugins.get_lsp_specs()
      for _, spec in ipairs(lsp_specs) do
        if spec.linter then
          local linters = {}
          for linter, _ in pairs(spec.linter) do
            table.insert(linters, linter)
          end
          for _, ft in ipairs(spec.ft or {}) do
            opts[ft] = linters
          end
        end
      end
      return opts
    end,
    config = function(_, opts)
      local lint = require("lint")
      lint.linters_by_ft = opts
      local lsp_specs = plugins.get_lsp_specs()
      for _, spec in ipairs(lsp_specs) do
        if spec.linter then
          for linter, lint_cfg in pairs(spec.linter) do
            if type(lint_cfg) == "function" then
              lint.linters[linter] = lint_cfg
            elseif type(lint_cfg) == "table" then
              for key, value in pairs(lint_cfg) do
                lint.linters[linter][key] = value
              end
            end
          end
        end
      end
    end,
  },
}

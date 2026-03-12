--- @module "plugins.lang.format"
--- This module configures formatters for Neovim.

local config = require("util.config")

return {
  {
    "stevearc/conform.nvim",
    cond = function()
      return config.plugin_enabled("conform")
    end,
    opts = function()
      --- @type conform.setupOpts
      local opts = {
        formatters_by_ft = {
          ["*"] = { "trim_whitespace" },
        },
        formatters = {
          crlfmt = {
            command = "crlfmt",
            args = {
              "-tab=2",
              "-wrap=100",
              "-ignore", "'.(pb(.gw)?)|(\\.[eo]g)\\.go|/testdata/|^sql/parser/sql\\.go$|_generated(_test)?\\.go$'",
              "-w", "$FILENAME",
            },
            stdin = false,
            inherit = false,
          },
        },
        format_after_save = {
          async = true,
          lsp_format = "fallback",
        }
      }
      local lsp_specs = require("util.plugins").get_lsp_specs()
      for _, spec in ipairs(lsp_specs) do
        if spec.formatter ~= nil then
          for _, ft in ipairs(spec.ft or {}) do
            opts.formatters_by_ft[ft] = spec.formatter
          end

          --- @type string[]
          local formatters = spec.formatter
          if type(spec.formatter) == "function" then
            formatters = spec.formatter(0)
          end
          for _, formatter in ipairs(formatters or {}) do
            if opts.formatters[formatter] == nil then
              opts.formatters[formatter] = {}
            end
          end
        end
      end

      -- Always write to /tmp for any tempfiles
      for _, formatter in pairs(opts.formatters) do
        formatter.tmpfile_format =  "/tmp/.conform.$RANDOM.$FILENAME"
      end

      return opts
    end
  }
}

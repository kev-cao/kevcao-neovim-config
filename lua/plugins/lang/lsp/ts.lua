--- @module "plugins.lang.lsp.ts"
--- This module configures the the TypeScript language server for Neovim and
--- related plugins.

local config = require("util.config")

--- @type LspSpec
return {
  lsp = {"tsserver"},
  ft = { "ts", "tsx", "js", "jsx" },
  {
    "pmizio/typescript-tools.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
    },
    cond = function()
      return config.plugin_enabled("lsp-config")
    end,
    config = function(_, opts)
      require("typescript-tools").setup(opts)
    end,
  },
}

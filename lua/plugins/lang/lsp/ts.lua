--- @module "plugins.lang.lsp.ts"
--- This module configures the the TypeScript language server for Neovim and
--- related plugins.

local func = require("util.func")

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
      return func.check_global_var("use_lsp", true, true)
    end,
    config = function(_, opts)
      require("typescript-tools").setup(opts)
    end,
  },
}

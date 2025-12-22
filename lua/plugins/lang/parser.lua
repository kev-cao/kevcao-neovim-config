--- @module "plugins.lang.parser"
--- This module configures language parsers and related plugins for Neovim.

local func = require("util.func")

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    cond = function()
      return func.check_global_var("use_treesitter", true, true)
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      max_lines = 3,
    },
    cond = function()
      return func.check_global_var("use_treesitter", true, true)
    end,
  },
}

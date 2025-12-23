--- @module "plugins.lang.parser"
--- This module configures language parsers and related plugins for Neovim.

local config = require("util.config")

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    cond = function()
      return not config.is_plugin_disabled("treesitter")
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
      return not config.is_plugin_disabled("treesitter")
    end,
  },
}

--- @module 'plugins.fs'
--- All file system related plugins

local config = require("util.config")
local keymaps = require("config.keymaps")

return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      -- Nerd fonts for icons
      "nvim-tree/nvim-web-devicons",
    },
    keys = keymaps.nvim_tree.keys,
    init = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      vim.g.nvim_tree_width = 30
    end,
    lazy = false,
    cond = function()
      return config.plugin_enabled("nvim-tree")
    end,
    config = function()
      require("nvim-tree").setup()
    end,
  },
  {
    'stevearc/oil.nvim',
    cond = function()
      return config.plugin_enabled("oil")
    end,
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      use_default_keymaps = false,
      skip_confirm_for_simple_edits = true,
    },
    keys = keymaps.oil.keys,
    dependencies = { "nvim-tree/nvim-web-devicons" },
  }
}

--- @module 'plugins.git'
--- Git related plugins

local config = require("util.config")
local keymaps = require("config.keymaps")

return {
  {
    "pwntester/octo.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "ibhagwan/fzf-lua",
      "nvim-tree/nvim-web-devicons",
    },
    cond = function()
      return not config.is_plugin_disabled("octo")
    end,
    keys = keymaps.octo.keys,
    opts = {
      picker = "fzf-lua",
      mappings_disable_default = false,
      mappings = keymaps.octo.bufkeys,
    },
    config = function(_, opts)
      require("octo").setup(opts)
    end,
  },
  {
    "kdheepak/lazygit.nvim",
    init = function()
      vim.g.lazygit_use_custom_config_file_path = 1
      vim.g.lazygit_config_file_path = vim.fn.expand("$HOME/.config/lazygit/config.yml")
    end,
    dependencies = {
      { "nvim-lua/plenary.nvim" },
    },
    cond = function()
      return not config.is_plugin_disabled("lazygit")
    end,
    keys = keymaps.lazygit.keys,
  },
  {
    "tpope/vim-fugitive",
    keys = keymaps.fugitive.keys,
    cond = function()
      return not config.is_plugin_disabled("fugitive")
    end,
  },
  {
    "tpope/vim-rhubarb",
    dependencies = {
      { "tpope/vim-fugitive" },
    },
    cond = function()
      return not config.is_plugin_disabled("fugitive")
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    keys = keymaps.gitsigns.keys,
    event = { "BufRead", "BufNewFile" },
    config = function()
      require("gitsigns").setup()
    end,
    cond = function()
      return not config.is_plugin_disabled("gitsigns")
    end,
  },
}

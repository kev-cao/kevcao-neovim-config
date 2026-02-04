--- @module 'plugins.terminal'
--- Terminal related plugins

local config = require("util.config")
local keymaps = require("config.keymaps")

return {
  {
    "voldikss/vim-floaterm",
    keys = keymaps.floaterm.keys,
    init = function()
      vim.g.floaterm_wintype = "split"
      vim.g.floaterm_position = "botright"
      vim.g.floaterm_height = 0.2
    end,
    cond = function()
      return config.plugin_enabled("floaterm")
    end,
  },
}

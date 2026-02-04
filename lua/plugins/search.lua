--- @module 'plugins.search'
--- Search related plugins

local config = require("util.config")
local keymaps = require("config.keymaps")

return {
  {
    "ibhagwan/fzf-lua",
    opts = function()
      local fzf = require("fzf-lua")
      return {
        keymap = {
          fzf = keymaps.fzf.fzfkeys,
        },
        marks = {
          marks = "[A-Za-z]",
        },
        fzf_opts = {
          ["--info"] = "inline",
          ["-i"] = true, -- case insensitive
        },
        actions = {
          files = {
            true,
            ["ctrl-r"] = { fzf.actions.toggle_ignore },
          },
          grep = {
            true,
            ["ctrl-r"] = { fzf.actions.toggle_ignore },
          }
        },
        winopts = {
          preview = {
            layout = "vertical",
          },
        },
        lsp = {
          async_or_timeout = 10000,
        },
        grep = {
          formatter = "path.filename_first",
        },
      }
    end,
    keys = keymaps.fzf.keys,
    config = function(_, opts)
      require("fzf-lua").setup(opts)
      vim.cmd("FzfLua register_ui_select")
    end,
    cond = function()
      return config.plugin_enabled("fzf")
    end,
  },
}

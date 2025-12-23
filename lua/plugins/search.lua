--- @module 'plugins.search'
--- Search related plugins

local config = require("util.config")
local keymaps = require("config.keymaps")

return {
  {
    "ibhagwan/fzf-lua",
    opts = {
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
    },
    keys = keymaps.fzf.keys,
    config = function(_, opts)
      require("fzf-lua").setup(opts)
      vim.cmd("FzfLua register_ui_select")
    end,
    cond = function()
      return not config.is_plugin_disabled("fzf")
    end,
  },
}

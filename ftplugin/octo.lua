local func = require("util.func")
local config = require("util.config")
local keymaps = require("config.keymaps")

vim.cmd("setlocal textwidth=0")
if not config.is_plugin_disabled("which-key") then
  local wk = require("which-key")
  wk.add(func.make_buflocal(keymaps.octo.bufgroups))
end

local func = require("util.func")
local config = require("util.config")
local keymaps = require("config.keymaps")

if config.plugin_enabled("which-key") then
  local wk = require("which-key")
  wk.add(func.make_buflocal(keymaps.neotest["output-panel"]))
else
  for _, map in ipairs(keymaps.neotest["output-panel"]) do
    vim.keymap.set(map.mode, map[1], map[2], {
      buffer = 0,
      desc = map.desc,
    })
  end
end

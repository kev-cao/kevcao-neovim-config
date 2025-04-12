local func = require('util.func')
local keymaps = require('config.keymaps')

vim.cmd('setlocal textwidth=0')
for _, map in ipairs(keymaps.neorg.bufkeys) do
  vim.keymap.set(map.mode, map[1], map[2], {
    buffer = 0,
    desc = map.desc,
  })
end
if func.check_global_var('use_which_key', true, false) then
  local wk = require('which-key')
  wk.add(keymaps.neorg.bufgroups)
end


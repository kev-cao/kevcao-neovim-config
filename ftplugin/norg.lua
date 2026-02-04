local func = require("util.func")
local config = require("util.config")
local keymaps = require("config.keymaps")

vim.cmd("setlocal textwidth=100")

if config.plugin_enabled("which-key") then
  local wk = require("which-key")
  wk.add(func.make_buflocal(keymaps.neorg.bufgroups))
  wk.add(func.make_buflocal(keymaps.neorg.bufkeys))
else
  for _, map in ipairs(keymaps.neorg.bufkeys) do
    vim.keymap.set(map.mode, map[1], map[2], {
      buffer = 0,
      desc = map.desc,
    })
  end
end

if pcall(vim.treesitter.start) then
  vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
  vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
end

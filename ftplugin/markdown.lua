local config = require("util.config")

local curr_file = vim.fn.expand("%:p")
local obsidian_vault = config.get_local(
  "obsidian_vault_path", vim.fn.expand("~/Documents/obsidian")
)
local obsidian_pattern = vim.fn.glob2regpat(obsidian_vault .. "/*.md")

if vim.fn.match(curr_file, obsidian_pattern) == -1 then
  return
end

vim.cmd("setlocal textwidth=100")

local keymaps = require("config.keymaps")
if not config.is_plugin_disabled("which-key") then
  local wk = require("which-key")
  local func = require("util.func")
  wk.add(func.make_buflocal(keymaps.obsidian.bufkeys))
else
  for _, map in ipairs(keymaps.obsidian.bufkeys) do
    vim.keymap.set(map.mode, map[1], map[2], {
      buffer = 0,
      desc = map.desc,
    })
  end
end

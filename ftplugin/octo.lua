local func = require("util.func")
local keymaps = require("config.keymaps")

vim.cmd("setlocal textwidth=0")
if func.check_global_var("use_which_key", true, false) then
    local wk = require("which-key")
    wk.add(func.make_buflocal(keymaps.octo.bufgroups))
end

--- @module 'autocmds.lua
--- This file contains all the autocommands for Neovim
---
local func = require("util.func")
local keymaps = require("config.keymaps")

vim.api.nvim_create_augroup("formatter", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
  group = "formatter",
  pattern = "*",
  callback = function()
    if func.check_global_var("use_formatter", true, false) then
      vim.cmd("FormatWrite")
    end
  end,
})

-- Don't clear the clipboard on exit
vim.api.nvim_create_autocmd("VimLeave", {
  pattern = "*",
  callback = function()
    local clip = vim.fn.getreg("+")
    local esc = vim.fn.shellescape(clip)
    local cmd = "echo " .. esc .. " | xclip -selection clipboard"
    vim.fn.system(cmd)
  end,
})

--[[
-- ==========================================================
-- ========================= Git ============================
-- ==========================================================
--]]
vim.api.nvim_create_augroup("git", { clear = true })
vim.api.nvim_create_autocmd({ "BufWinEnter", "WinNew" }, {
  group = "git",
  pattern = "*",
  callback = function(args)
    if not func.check_global_var("use_fugitive", true, false) then
      return
    end
    -- We schedule because we need the window to be populated with the buffer
    -- first.
    vim.schedule(function()
      if vim.wo.diff then
        for _, map in ipairs(keymaps.fugitive.buflocal) do
          vim.keymap.set(map.mode, map[1], map[2], {
            buffer = args.buf,
            desc = map.desc,
          })
        end
      end
    end)
  end,
})

vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter" }, {
  group = "git",
  pattern = "*",
  callback = function(args)
    if not func.check_global_var("use_fugitive", true, false) then
      return
    end
    -- We schedule because we need the window to be populated with the buffer
    -- first.
    vim.schedule(function()
      if vim.wo.diff then
        local file = vim.api.nvim_buf_get_name(args.buf)
        local is_main = not file:match("^fugitive://")
        if not is_main then
          return
        end

        for _, map in ipairs(keymaps.fugitive.mainbuflocal) do
          vim.keymap.set(map.mode, map[1], map[2], {
            buffer = args.buf,
            desc = map.desc,
          })
        end
      end
    end)
  end,
})

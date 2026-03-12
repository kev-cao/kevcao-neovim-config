--- @module "util.keymaps"
--- A central place to store custom keymap definitions.

local M = {
  git = {
    mergetool = {}
  }
}
local func = require("util.func")

--- Helper function to expand Neotest UI.
--- @param opts { open: boolean, close: boolean, clear: boolean } | nil
function M.toggle_neotest_ui(opts)
  if opts == nil then
    opts = {}
  end
  if opts.close then
    require("neotest").output_panel.close()
    require("neotest").summary.close()
  elseif opts.open then
    require("neotest").output_panel.open()
    require("neotest").summary.open()
  else
    require("neotest").output_panel.toggle()
    require("neotest").summary.toggle()
  end

  if opts.clear then
    require("neotest").output_panel.clear()
  end
end

--- Copies the file path of the current buffer to the clipboard and displays it
--- in a notification. The path is made relative to the current working
--- directory, or if that is not possible, relative to the home directory. If
--- that also fails, the absolute path is copied and displayed.
function M.copy_current_filepath()
  local filepath = vim.api.nvim_buf_get_name(0)
  if filepath == "" then
    vim.notify("No file path to copy", vim.log.levels.ERROR)
    return
  end
  local relpath = vim.fn.fnamemodify(filepath, ":~:.")
  vim.fn.setreg('+', filepath)
  vim.notify(relpath, vim.log.levels.INFO)
end

--- Copies the Git commit hash of the current line to the clipboard
function M.git.copy_git_hash()
  local bufnr = vim.api.nvim_get_current_buf()
  local filename = vim.api.nvim_buf_get_name(bufnr)
  local row = vim.api.nvim_win_get_cursor(0)[1]
  -- Use --porcelain to get machine-readable output and extract the hash
  local blame_info = vim.fn.systemlist('git blame -L ' .. row .. ',+1 --porcelain -- ' .. filename)

  if #blame_info >= 1 then
    -- The first line of porcelain output contains the hash
    local hash = string.sub(blame_info[1], 1, 40) -- Get full SHA
    -- Copy to clipboard
    vim.fn.setreg('+', hash)
    vim.notify("Copied commit hash: " .. string.sub(hash, 1, 8), vim.log.levels.INFO) -- Print a truncated hash for confirmation
  else
    print("Could not get git blame info", vim.log.levels.ERROR)
  end
end

--- If there are merge conflicts, opens a new tab and launches :Git mergetool in
--- a three way split.
function M.git.mergetool.open()
  if not func.in_git_repo() then
    vim.notify("Not in a git repository.", vim.log.levels.ERROR)
    return
  end
  if not func.has_merge_conflicts() then
    vim.notify("No merge conflicts found.", vim.log.levels.INFO)
    return
  end

  vim.cmd("tabnew")
  vim.cmd("Git mergetool")
  vim.schedule(function()
    local qf = vim.fn.getqflist()
    if #qf == 0 then
      vim.notify("No merge conflicts found.", vim.log.levels.INFO)
      return
    end

    -- Open quickfix, jump to the first entry, then launch the 3-way diff
    vim.cmd("copen")   -- show the list (focus usually stays in the edit window)
    local qfwin = vim.fn.getqflist({ winid = 1 }).winid
    if qfwin ~= 0 then
      vim.fn.win_gotoid(qfwin)
      vim.cmd("wincmd J | resize 15")
      vim.cmd("wincmd p")  -- return focus to edit window
    end
    vim.cmd("cc 1")       -- open the 1st quickfix entry in the current window
    vim.cmd("Gvdiffsplit!") -- start Fugitive’s 3-way diff on that file
  end)
end

--- Writes the current changes in the Git mergetool and moves to the next
--- conflict, or closes the tab if all conflicts are resolved.
function M.git.mergetool.write()
  vim.cmd("Gwrite!")
  vim.cmd("Git mergetool")
  local qf = vim.fn.getqflist()
  if #qf == 0 then
    vim.notify("All conflicts resolved", vim.log.levels.INFO)
    vim.cmd("tabc")
    return
  end
  vim.cmd("cc 1")
  vim.cmd("Gvdiffsplit!")
end

--- Moves to the next conflicting file in the Git mergetool.
function M.git.mergetool.next_file()
  local qfinfo = vim.fn.getqflist({ idx = 0, size = 0 })
  local curr  = qfinfo.idx   -- current entry index (1-based, 0 if none)
  local total = qfinfo.size  -- number of entries
  if curr == 0 then
    vim.notify("No more conflict entries.", vim.log.levels.ERROR)
  end
  vim.cmd("only")
  vim.cmd("botright copen 15")
  if curr == total then
    vim.cmd("cfirst")
  else
    vim.cmd("cnext")
  end
  vim.cmd("Gvdiffsplit!")
end

--- Moves to the previous conflicting file in the Git mergetool.
function M.git.mergetool.prev_file()
  local qfinfo = vim.fn.getqflist({ idx = 0, size = 0 })
  local curr  = qfinfo.idx   -- current entry index (1-based, 0 if none)
  if curr == 0 then
    vim.notify("No more merge conflict entries.", vim.log.levels.ERROR)
  end
  vim.cmd("only")
  vim.cmd("botright copen 15")
  if curr == 1 then
    vim.cmd("clast")
  else
    vim.cmd("cprev")
  end
  vim.cmd("Gvdiffsplit!")
end

return M

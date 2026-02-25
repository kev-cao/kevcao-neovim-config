--- @module "util.sys"
--- Offors utility functions for system operations

local M = {}

function M.which(exec)
  local handle = io.popen("which " .. exec .. " 2>/dev/null")
  if not handle then
    vim.notify("Failed to execute 'which' command for " .. exec, vim.log.levels.ERROR)
    return nil
  end
  local result = handle:read("*a")
  handle:close()
  if result == "" then
    return nil
  else
    return result:gsub("%s+", "")
  end
end

return M

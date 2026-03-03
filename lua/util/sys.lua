--- @module "util.sys"
--- Offors utility functions for system operations

local M = {}

--- Checks if an executable is available in the system's PATH and returns its full path if found.
--- @param exec string The name of the executable to check
--- @return string|nil The full path to the executable if found, or nil if not
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

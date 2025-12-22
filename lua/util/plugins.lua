--- @module "util.plugins"
--- This module provides utility functions for navigating the plugins directory
--- in this Neovim configuration.

local M = {}

--- Gets all language specific specs in plugins/lang/lsp.
--- @return _ table A table containing all language specific specs, containing
--- related plugins and configurations.
function M.get_lsp_specs()
  local uv = vim.loop
  local stats = uv.fs_readdir(uv.fs_opendir(vim.fn.stdpath('config') .. "/lua/plugins/lang/lsp", nil, 1000))
  if not stats then
    return
  end

  local specs = {}
  for _, stat in ipairs(stats) do
    if stat.type ~= "file" then
      goto continue
    end
    local module_name = stat.name:match("^(.*)%.lua$")
    if not module_name or module_name == "lsp" then
      goto continue
    end

    local ok, module = pcall(require, "plugins.lang.lsp." .. module_name)
    if not ok then
      vim.notify(
        "Failed to load module plugins.lang.lsp." .. module_name .. ": " .. module,
        vim.log.levels.ERROR
      )
      goto continue
    end
    if type(module) ~= "table" then
      vim.notify(
        "Module plugins.lang.lsp." .. module_name .. " did not return a table",
        vim.log.levels.ERROR
      )
      goto continue
    end

    table.insert(specs, module)
    ::continue::
  end

  return specs
end

--- Generates import specifications for all init.lua files found in the
--- subdirectories of the given subdirectory.
--- @param dir string The subdirectory in plugins/ to search.
--- @return _ table A table merging all import specifications found in each
local function generate_import_specs(dir)
  local uv = vim.loop
  local stats = uv.fs_readdir(uv.fs_opendir(vim.fn.stdpath('config') .. "/lua/plugins/" .. dir, nil, 1000))
  if not stats then
    return
  end

  local import_specs = {}
  for _, stat in ipairs(stats) do
    if stat.type == "directory" then
      local recursed_specs = generate_import_specs(dir .. "/" .. stat.name)
      vim.tbl_extend("error", import_specs, recursed_specs)
    end

    if stat.name ~= "init.lua" or dir == "" then
      goto continue
    end

    local init_path = "plugins." .. dir .. ".init"
    local ok, module = pcall(require, init_path)
    if not ok then
      vim.notify(
        "Failed to load module " .. init_path .. ": " .. module,
        vim.log.levels.ERROR
      )
      goto continue
    end
    if type(module) ~= "table" then
      vim.notify(
        "Module " .. init_path .. " did not return a table",
        vim.log.levels.ERROR
      )
      goto continue
    end

    vim.tbl_extend("error", import_specs, module)
    ::continue::
  end

  return import_specs
end


--- Looks for init.lua files in plugin/ subdirectories and generates import
--- specifications for them.
--- @return _ table A table merging all import specifications found in each
--- plugin subdirectory.
function M.generate_plugin_import_specs()
  return generate_import_specs("")
end

return M

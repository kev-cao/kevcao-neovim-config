--- @module "util.config"
--- Offers functions to access local configuration settings

local M = {}

--- @alias ConfigKey
--- | "node_path"
--- | "ai_assistant"
--- | "disabled_plugins"
--- | "obsidian_vault_path"

--- @class LocalConfig<ConfigKey>
--- @field node_path? string
--- @field ai_assistant? "claude" | "opencode"
--- @field disabled_plugins? table<string, boolean>
--- @field obsidian_vault_path? string

--- Gets the value of a local configuration variable from config/local.lua. If
--- no such variable exists, returns the provided default value.
--- @generic K: ConfigKey
--- @param key K: The key of the local configuration variable to retrieve.
--- @param default LocalConfig<K>: The default value to return if the variable is not set.
--- @return LocalConfig<K>: The value of the local configuration variable, or the default value.
function M.get_local(key, default)
  local ok, local_config = pcall(require, "config.local")
  if not ok then
    return default
  end
  return local_config[key] or default
end

--- Checks if a plugin is disabled. Local configurations in config/local.lua
--- are checked first before falling back to global variables defined in
--- config/general.lua.
--- @param plugin string: The name of the plugin to check.
--- @return boolean: True if the plugin is disabled, false otherwise.
function M.is_plugin_disabled(plugin)
  local ok, local_config = pcall(require, "config.local")
  if not ok then
    return false
  end
  if local_config.disabled_plugins ~= nil then
    if local_config.disabled_plugins[plugin] ~= nil then
      return local_config.disabled_plugins[plugin]
    end
  end
  -- Fallback to global settings
  local global_var = "use_" .. plugin:gsub("[-.]", "_")
  local use_plugin = vim.g[global_var]
  if use_plugin == false then
    return true
  end
  -- Default to all plugins being enabled
  return false
end

return M

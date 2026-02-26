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
  if not ok or local_config == true then
    return default
  end
  return local_config[key] or default
end

--- Checks if a plugin is enabled. Local configurations in config/local.lua
--- are checked first before falling back to global variables defined in
--- config/general.lua.
--- @param plugin string: The name of the plugin to check.
--- @return boolean: True if the plugin is enabled, false otherwise.
function M.plugin_enabled(plugin)
  -- Fallback to global settings
  local global_var = "use_" .. plugin:gsub("[-.]", "_")
  local fallback = vim.g[global_var]
  if fallback == nil then
    -- Default all pluginns to enabled.
    fallback = true
  end

  local ok, local_config = pcall(require, "config.local")
  if not ok or local_config == true then
    return fallback
  end
  if local_config.disabled_plugins ~= nil then
    if local_config.disabled_plugins[plugin] ~= nil then
      return not local_config.disabled_plugins[plugin]
    end
  end

  return fallback
end

return M

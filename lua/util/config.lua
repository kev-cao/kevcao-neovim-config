--- @module "util.config"
--- Offers functions to access local configuration settings

local M = {}

--- @alias ConfigKey
--- | "node_path"
--- | "ai_assistant"

--- @class LocalConfig<ConfigKey>
--- @field node_path? string
--- @field ai_assistant? "claude" | "opencode"

--- Gets the value of a local configuration variable from config/local.lua. If
--- no such variable exists, returns the provided default value.
--- @generic K: ConfigKey
--- @param key K: The key of the local configuration variable to retrieve.
--- @param default any: The default value to return if the variable is not set.
--- @return LocalConfig<K>: The value of the local configuration variable, or the default value.
function M.get_local(key, default)
  local ok, local_config = pcall(require, "config.local")
  if not ok then
    return default
  end
  return local_config[key] or default
end

return M

--- @module "plugins.init"
--- This modules aggregates all nested plugin configurations in plugins/.

local plugins = require("util.plugins")

return plugins.generate_plugin_import_specs()

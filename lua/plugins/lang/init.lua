local plugins = require("util.plugins")

local M = {
  { import = "plugins.lang.cmp" },
  { import = "plugins.lang.lint" },
  { import = "plugins.lang.lsp.lsp" },
  { import = "plugins.lang.parser" }
}

--- This adds import specifications for specific languages from other files in
--- lang/lsp.
function M.generate_lsp_import_specs()
  local lsp_specs = plugins.get_lsp_specs()

  for _, spec in ipairs(lsp_specs) do
    for key, value in pairs(spec) do
      -- Add only plugin specifications from the table that are keyed to numbers,
      -- which indicate a plugin specification rather than some other
      -- configuration data.
      if type(key) == "number" then
        table.insert(M, value)
      end
    end
  end
end

M.generate_lsp_import_specs()

return M

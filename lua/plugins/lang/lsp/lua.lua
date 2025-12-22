--- @module 'plugins.langlsp.lua'
--- This module configures the Lua language server (lua-language-server) and
--- related plugins for Neovim.

--- @type LspSpec
return {
  lsp = {"lua_ls"},
  ft = { "lua" },
  opts = {
    cmd = { "lua-language-server" },
    settings = {
      Lua = {
        diagnostics = {
          enable = true,
          globals = { "vim" },
        },
      },
    },
  },
}

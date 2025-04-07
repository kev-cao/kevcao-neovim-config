--- @module 'lsp.lua'
--- This module configures the Lua language server (lua-language-server) for Neovim.

return {
  opts = {
    cmd = { 'lua-language-server' },
    settings = {
      Lua = {
        diagnostics = {
          enable = true,
          globals = { 'vim' },
        },
      },
    },
  }
}

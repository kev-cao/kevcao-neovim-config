--- @module 'plugins.lang.lsp.clangd'
--- This module configures the Clangd language server and related plugins for
--- Neovim.

--- @type LspSpec
return {
  lsp = {"clangd"},
  ft = { "c", "cpp", "objc", "objcpp", "cuda" },
  opts = {
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
  },
}

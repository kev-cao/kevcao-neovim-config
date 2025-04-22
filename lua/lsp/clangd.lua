--- @module 'lsp.clangd'
--- This module configures the Clangd language server for C/C++ development in Neovim.

return {
  opts = {
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
  },
}

--- @module 'plugins.lang.lsp.rust'
--- This module configures the Rust language server and related plugins for
--- Neovim.

--- @type LspSpec
return {
  lsp = { "rust_analyzer" },
  ft = { "rs" },
  {
    'mrcjkb/rustaceanvim',
    version = '^7', -- Recommended
    lazy = false, -- This plugin is already lazy
  },
  linter = { "clippy" },
}

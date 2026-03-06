--- @module 'plugins.lang.lsp.tf'
--- This module configures the Terraform language server and related plugins for
--- Neovim.

--- @type LspSpec
return {
  ft = { "tf", "terraform-vars" },
  formatter = { "tofu_fmt" },
}

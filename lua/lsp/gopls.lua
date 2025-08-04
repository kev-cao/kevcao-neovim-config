--- @module 'lsp.gopls'
--- This module configures the Go language server (gopls) for Neovim.

return {
  opts = {
    on_attach = function(client, bufnr)
      local uri = vim.uri_from_bufnr(bufnr)
      if vim.startswith(uri, "octo://") then
        vim.lsp.buf_detach_client(bufnr, client.id)
        return false
      end
      if not client.server_capabilities.semanticTokensProvider then
        local semantic = client.config.capabilities.textDocument.semanticTokens
        client.server_capabilities.semanticTokensProvider = {
          full = true,
          legend = { tokenModifiers = semantic.tokenModifiers, tokenTypes = semantic.tokenTypes },
          range = true,
        }
      end
      return true
    end,
    cmd = { "gopls" },
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    single_file_support = true,
    settings = {
      gopls = {
        semanticTokens = true,
        staticcheck = true,
        hints = {
          compositeLiteralFields = true,
          compositeLiteralTypes = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
        completeUnimported = true,
        deepCompletion = true,
        usePlaceholders = false,
        analyses = {
          SA4006 = true,
          unusedparams = true,
          nilness = true,
          unusedwrite = true,
          unusedvariable = true,
        },
      },
    },
  },
}

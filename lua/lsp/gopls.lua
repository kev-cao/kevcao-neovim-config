--- @module 'lsp.gopls'
--- This module configures the Go language server (gopls) for Neovim.

return {
  opts = {
    on_attach = function(client, bufnr)
      if not client then
        return false
      end

      local uri = vim.uri_from_bufnr(bufnr)
      local invalid_schemes = { "octo://", "fugitive://" }
      for _, scheme in ipairs(invalid_schemes) do
        if vim.startswith(uri, scheme) then
          return
        end
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
          ignoredError = true,
        },
        completeUnimported = true,
        deepCompletion = true,
        usePlaceholders = false,
        diagnosticsDelay = "250ms",
        analyses = {
          unusedparams = true,
          nilness = true,
          unusedwrite = true,
          unusedvariable = true,
          SA4006 = true,
        },
      },
    },
  },
}

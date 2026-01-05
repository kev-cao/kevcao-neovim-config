--- @module 'plugins.lang.lsp.go'
--- This module configures the Go language server and related plugins for
--- Neovim.

--- @type LspSpec
return {
  lsp = {"gopls"},
  ft = {"go"},
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
        directoryFilters = {
          "-**/node_modules",
          "-**/_bazel",
          "-**/bazel-bin",
          "-**/bazel-out",
          "-**bazel-testlogs",
          "-**/vendor",
          "-**/inflight_trace_dump",
          "-pkg/sql/colexec",
        },
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
  linter = { "golangcilint" },
  {
    "charlespascoe/vim-go-syntax",
    ft = { "go", "gomod", "gowork", "gotmpl" },
  },
}

--- @module 'lsp.gopls'
--- This module configures the Go language server (gopls) for Neovim.
local mod_cache = nil

return {
  opts = {
    on_attach = function(client, _)
      if not client.server_capabilities.semanticTokensProvider then
        local semantic = client.config.capabilities.textDocument.semanticTokens
        client.server_capabilities.semanticTokensProvider = {
          full = true,
          legend = { tokenModifiers = semantic.tokenModifiers, tokenTypes = semantic.tokenTypes },
          range = true,
        }
      end
    end,
    cmd = { "gopls" },
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    root_dir = function(fname)
      -- see: https://github.com/neovim/nvim-lspconfig/issues/804
      local async = require("lspconfig.async")
      local util = require("lspconfig/util")
      if not mod_cache then
        local result = async.run_command({ "go", "env", "GOMODCACHE" })
        if result and result[1] then
          mod_cache = vim.trim(result[1])
        else
          mod_cache = vim.fn.system("go env GOMODCACHE")
        end
      end
      if mod_cache and fname:sub(1, #mod_cache) == mod_cache then
        local clients = util.get_lsp_clients({ name = "gopls" })
        if #clients > 0 then
          return clients[#clients].config.root_dir
        end
      end
      return util.root_pattern("go.work", "go.mod", ".git")(fname)
    end,
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
        usePlaceholders = true,
        analyses = {
          unusedparams = true,
        },
      },
    },
  },
}

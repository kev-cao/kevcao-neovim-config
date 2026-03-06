local config = require("util.config")
local keymaps = require("config.keymaps")

--- @class LspSpec
--- @field ft string[] Filetypes that linters and formatters will apply to (output of vim.bo.filetype)
--- @field lsp? table<string, vim.lsp.Config|nil> Mapping of LSPs to their options, or nil for defaults.
--- @field linter? table<string, PartialLinter|(fun(): lint.Linter)|nil> Linters to use mapped to their configuration, or nil for defaults.
--- @field formatter? conform.FiletypeFormatter Formatters to use


--- @class (partial) PartialLinter: lint.Linter

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufRead", "BufWinEnter", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "junegunn/fzf",
    },
    opts = function()
      local opts = {
        capabilities = {},
        servers = {},
      }
      local plugins = require("util.plugins")
      local lsp_specs = plugins.get_lsp_specs()
      for _, spec in pairs(lsp_specs) do
        for lsp, lsp_opts in pairs(spec.lsp or {}) do
          if lsp_opts ~= nil then
            opts.servers[lsp] = lsp_opts
          end
        end
      end
      return opts
    end,
    config = function(_, opts)
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        require("cmp_nvim_lsp").default_capabilities(),
        vim.lsp.protocol.make_client_capabilities(),
        opts.capabilities or {}
      )
      local function on_attach(client, bufnr)
        if client == nil then
          return
        end

        if client.server_capabilities.documentHighlightProvider then
          vim.api.nvim_create_augroup("lsp_hover", { clear = false })
          vim.api.nvim_clear_autocmds({ buffer = bufnr, group = "lsp_hover" })
          vim.api.nvim_create_autocmd("CursorHold", {
            buffer = bufnr,
            group = "lsp_hover",
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd("CursorHoldI", {
            buffer = bufnr,
            group = "lsp_hover",
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd("CursorMoved", {
            buffer = bufnr,
            group = "lsp_hover",
            callback = vim.lsp.buf.clear_references,
          })
        end
      end

      vim.lsp.config("*", {
        capabilities = capabilities,
        on_attach = on_attach,
      })

      for server_name, server in pairs(opts.servers) do
        local server_on_attach = function(client, bufnr)
          if server.on_attach then
            if not server.on_attach(client, bufnr) then
              return
            end
          end
          on_attach(client, bufnr)
        end
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = capabilities,
          handlers = {
            ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
              border = "rounded",
            }),
          },
        }, server, { on_attach = server_on_attach })
        vim.lsp.config(server_name, server_opts)
      end
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })
      require("mason-lspconfig").setup({
        ensure_installed = vim.tbl_keys(opts.servers),
        automatic_enable = true,
      })
    end,
    keys = keymaps.lsp.keys,
    cond = function()
      return config.plugin_enabled("lsp-config")
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    lazy = false,
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    cond = function()
      return config.plugin_enabled("lsp-config")
    end,
  },
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "zeioth/garbage-day.nvim",
    depedencies = "neovim/nvim-lspconfig",
    event = "VeryLazy",
  },
}

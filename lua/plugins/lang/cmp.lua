--- @module 'plugins.cmp'
--- All the completion related plugins are defined here.

local config = require("util.config")

return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
    },
    event = "InsertEnter",
    cond = function()
      return config.plugin_enabled("cmp")
    end,
    opts = function()
      local cmp = require("cmp")
      local has_luasnip, luasnip = pcall(require, "luasnip")
      return {
        enabled = function()
          local disabled = false
          disabled = disabled or (vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "prompt")
          disabled = disabled or (vim.fn.reg_recording() ~= "")
          disabled = disabled or (vim.fn.reg_executing() ~= "")
          disabled = disabled or require("cmp.config.context").in_treesitter_capture("comment")
          return not disabled
        end,
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        completion = {
          completeopt = "noselect",
        },
        mapping = {
          ['<Down>'] = {
            i = cmp.mapping.select_next_item(),
          },
          ['<Up>'] = {
            i = cmp.mapping.select_prev_item(),
          },
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.confirm({ select = true })
            else
              fallback()
            end
          end),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif has_luasnip and luasnip.locally_jumpable(1) then
              luasnip.jump(1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif has_luasnip and luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        },
        preselect = cmp.PreselectMode.None,
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "lazydev" },
        }, {
          { name = "[Neorg]" },
        }),
      }
    end,
    config = function(_, opts)
      local cmp = require("cmp")
      cmp.setup(opts)
      -- `:` cmdline setup.
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
          {
            name = "cmdline",
            option = {
              ignore_cmds = { "Man", "!" },
            },
          },
        }),
      })
      -- `/` cmdline setup.
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })
    end,
  },
  {
    "saadparwaiz1/cmp_luasnip",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "hrsh7th/nvim-cmp",
    },
    cond = function()
      return config.plugin_enabled("snippet")
    end,
  },
  {
    "rafamadriz/friendly-snippets",
    dependencies = {
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      require("luasnip").filetype_extend("javascriptreact", { "html" })
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
  },
}

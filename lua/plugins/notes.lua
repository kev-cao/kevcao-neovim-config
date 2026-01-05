--- @module 'plugins.org'
--- Note-taking plugin configuration

local config = require("util.config")
local keymaps = require("config.keymaps")

return {
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    cond = not config.is_plugin_disabled("obsidian.nvim"),
    lazy = true,
    event = {
      -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
      -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
      -- refer to `:h file-pattern` for more examples
      "BufReadPre " .. config.get_local(
        "obsidian_vault_path", vim.fn.expand("~/Documents/obsidian")
      ) .. "/*.md",
      "BufNewFile " .. config.get_local(
        "obsidian_vault_path", vim.fn.expand("~/Documents/obsidian")
      ) .. "/*.md",
    },
    keys = keymaps.obsidian.keys,
    opts = {
      workspaces = {
        {
          name = "obsidian",
          path = config.get_local(
            "obsidian_vault_path", "~/Documents/obsidian"
          ),
        },
      },
      picker = {
        name = "fzf-lua",
      },
    },
  },
  {
    "nvim-neorg/neorg",
    dependencies = {
      "kev-cao/neorg-fzflua",
      "benlubas/neorg-conceal-wrap",
    },
    lazy = false,
    branch = "main",
    cond = not config.is_plugin_disabled("neorg"),
    opts = {
      load = {
        ["core.defaults"] = {},
        ["core.concealer"] = {},
        ["core.dirman"] = {
          config = {
            workspaces = {
              notes = "~/org-mode/notes",
            },
          },
        },
        ["core.keybinds"] = {
          config = {
            default_keybinds = false,
          },
        },
        ["core.completion"] = {
          config = {
            engine = "nvim-cmp",
          },
        },
        ["core.export"] = {
          config = {
            export_dir = "~/org-mode/exports",
          },
        },
        ["external.conceal-wrap"] = {},
        ["external.integrations.fzf-lua"] = {
          config = {
            workspace_location = "~/org-mode",
          },
        },
      },
    },
    keys = keymaps.neorg.keys,
    config = function(_, opts)
      require("neorg").setup(opts)
    end,
  },
}

--- @module 'plugins.org'
--- Orgmode plugin configuration

local func = require("util.func")
local keymaps = require("config.keymaps")

return {
  {
    "nvim-neorg/neorg",
    dependencies = {
      "kev-cao/neorg-fzflua",
      "benlubas/neorg-conceal-wrap",
    },
    lazy = false,
    version = "*",
    cond = func.check_global_var("use_neorg", true, true),
    opts = {
      load = {
        ["core.defaults"] = {},
        ["core.concealer"] = {},
        ["core.dirman"] = {
          config = {
            workspaces = {
              notes = "~/org-mode/notes",
              todos = "~/org-mode/todos",
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

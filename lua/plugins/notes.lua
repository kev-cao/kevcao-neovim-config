--- @module 'plugins.org'
--- Note-taking plugin configuration

local config = require("util.config")
local keymaps = require("config.keymaps")

return {
  {
    "obsidian-nvim/obsidian.nvim",
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
      legacy_commands = false,
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
        note_mappings = {
          new = "<C-n>",
          insert_link = "<C-l>",
        },
      },
      attachments = {
        folder = "attachments",
      },
      note_id_func = function(title)
        return title
      end,
      frontmatter = {
        func = function(note)
          local out = {
            aliases = note.aliases,
            categories = {},
          }
          if note.tags ~= nil then
            out.tags = note.tags
          end
          -- `note.metadata` contains any manually added fields in the frontmatter.
          -- So here we just make sure those fields are kept in the frontmatter.
          if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
            for k, v in pairs(note.metadata) do
              out[k] = v
            end
          end
          return out
        end,
      },
      templates = {
        folder = "nvim-templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
        substitutions = {
          today_week = function()
            return os.date("%Y-W%V")
          end,
          week_start_date = function()
            local current_time = os.time()
            local day_of_week_iso = tonumber(os.date("%u", current_time)) -- 1 (Mon) to 7 (Sun)
            local days_to_subtract = day_of_week_iso - 1
            local seconds_in_day = 60 * 60 * 24
            local first_day_time = current_time - (days_to_subtract * seconds_in_day)
            return os.date("%B %-e, %Y", first_day_time)
          end
        }
      },
      completion = {
        min_chars = 0,
      }
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

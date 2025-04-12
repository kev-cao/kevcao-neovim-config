--- @module 'plugins.org'
--- Orgmode plugin configuration

return {
  {
    'nvim-neorg/neorg',
    lazy = false,
    version = '*',
    opts = {
      load = {
        ['core.defaults'] = {},
        ['core.concealer'] = {},
        ['core.dirman'] = {
          config = {
            workspaces = {
              notes = '~/org-mode/notes',
              todos = '~/org-mode/todos',
            },
          },
        },
        ['core.keybinds'] = {
          config = {
            default_keybinds = false,
          }
        }
      },
    },
    config = function (_, opts)
      require('neorg').setup(opts)
    end,
  }
}

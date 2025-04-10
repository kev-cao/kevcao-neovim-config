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
        ["core.dirman"] = {
          config = {
            workspaces = {
              notes = "~/org-mode/notes",
              todos = "~/org-mode/todos",
            },
          },
        }
      },
    },
    config = function (_, opts)
      vim.api.nvim_create_augroup('neorg', { clear = true })
      vim.api.nvim_create_autocmd('BufEnter', {
        group = 'neorg',
        pattern = '*.norg',
        callback = function()
          vim.cmd('setlocal textwidth=0')
        end
      })
      require('neorg').setup(opts)
    end,
  }
}

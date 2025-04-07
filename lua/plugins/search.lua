local func = require('util.func')
local keymaps = require('config.keymaps')

return {
  {
    'junegunn/fzf',
    -- fzf must be installed
    dependencies = {
      'ibhagwan/fzf-lua',
    },
    opts = {
      marks = {
        marks = '[A-Za-z]',
      },
      fzf_opts = {
        ['--info'] = 'inline',
        ['-i'] = true, -- case insensitive
      },
      winopts = {
        preview = {
          layout = 'vertical',
        },
      },
      lsp = {
        async_or_timeout = 10000,
      },
      grep = {
        formatter = "path.filename_first",
      },
    },
    keys = keymaps.fzf.keys,
    config = function(_, opts)
      require('fzf-lua').setup(opts)
    end,
    cond = function()
      return func.check_global_var('use_fzf', true, true)
    end
  },
}

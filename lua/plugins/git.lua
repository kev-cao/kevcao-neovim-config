local func = require('util.func')
local keymaps = require('config.keymaps')

return {
  {
    'pwntester/octo.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'ibhagwan/fzf-lua',
      'nvim-tree/nvim-web-devicons',
    },
    cond = function()
      return func.check_global_var('use_octo', true, true)
    end,
    keys = keymaps.octo.keys,
    opts = {
      picker = 'fzf-lua',
      mappings_disable_default = false,
      mappings = keymaps.octo.mappings,
    },
    config = function(_, opts)
      require('octo').setup(opts)
    end
  },
  {
    'kdheepak/lazygit.nvim',
    init = function()
      vim.g.lazygit_use_custom_config_file_path = 1
      vim.g.lazygit_config_file_path = vim.fn.expand('$HOME/.config/lazygit/config.yml')
    end,
    dependencies = {
      {'nvim-lua/plenary.nvim'},
    },
    cond = function()
      return func.check_global_var('use_lazygit', true, true)
    end,
    keys = keymaps.lazygit.keys,
  },
  {
    'tpope/vim-fugitive',
    keys = keymaps.fugitive.keys,
    cond = function()
      return func.check_global_var('use_fugitive', true, true)
    end
  },
  {
    'tpope/vim-rhubarb',
    dependencies = {
      {'tpope/vim-fugitive'}
    },
    cond = function()
      return func.check_global_var('use_fugitive', true, true)
    end,
  },
  {
    'lewis6991/gitsigns.nvim',
    keys = keymaps.gitsigns.keys,
    event = { 'BufRead', 'BufNewFile' },
    config = function()
      require('gitsigns').setup()
    end,
    cond = function()
      return func.check_global_var('use_gitsigns', true, true)
    end,
  },
}

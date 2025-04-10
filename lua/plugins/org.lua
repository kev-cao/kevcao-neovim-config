--- @module 'plugins.org'
--- Orgmode plugin configuration

return {
  {
    'nvim-neorg/neorg',
    lazy = false,
    version = '*',
    load = {
      ['core.defaults'] = {}
    },
    config = true,
  }
}

--- @module 'general.lua'
--- This contains general settings that don't fit into any other category

local config = require("util.config")

-- Enabling and disabling plugins. This is set at the global level to be shared
-- across systems. For local overrides, use config/local.lua.
vim.g.use_virtcolumn = false -- bug with covering text, waiting for https://github.com/xiyaowong/virtcolumn.nvim/pull/11
vim.g.use_neotest = true
vim.g.use_neorg = false
vim.g.use_nvim_test = not config.plugin_enabled("neotest")

vim.g.nvim_tree_width = 30

vim.opt.colorcolumn = { "80", "100" }
vim.opt.hlsearch = true
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.textwidth = 80
vim.opt.formatoptions = "cqj"
vim.opt.ruler = true
vim.opt.cmdheight = 1
vim.opt.updatetime = 750
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.guicursor = "n-v-c-sm:block-blinkwait100-blinkoff20-blinkon20,"
  .. "i-ci-ve:ver25-blinkwait100-blinkoff20-blinkon20,"
  .. "r-cr-o:hor20-blinkwait100-blinkoff20-blinkon20"
vim.opt.termguicolors = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.ssop:append({ "curdir" })
vim.opt.ssop:remove("blank")
vim.opt.conceallevel = 2

vim.g.floaterm_wintype = "split"
vim.g.floaterm_position = "botright"
vim.g.floaterm_width = 0.2

vim.g.tex_flavor = "latex"
vim.g.vimtex_view_method = "zathura"
vim.g.vimtex_view_general_viewer = "okular"
vim.g.vimtex_view_general_options = "--unique file:@pdf\\#src:@line@tex"
vim.g.vimtex_quickfix_ignore_filters = {
  "Underfull",
  "Overfull",
  "does not make sense",
  "Non standard sectioning",
}

if vim.g.use_treesitter then
  vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
end

-- Create the Terminal command using the API.
vim.api.nvim_create_user_command("Terminal", "botright vs | term", {})

-- Set up command-line abbreviations.
vim.cmd("cabbrev terminal Terminal")
vim.cmd("cabbrev term Terminal")

vim.diagnostic.config({
  virtual_text = true,
})

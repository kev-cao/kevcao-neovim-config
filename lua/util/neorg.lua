--- @module 'util.neorg'
--- Utility functions for Neorg

local M = {}

local function workspace_previewer()
  local builtin_ok, builtin = pcall(require, "fzf-lua.previewer.builtin")
  if not builtin_ok then
    return
  end

  local session_previewer = builtin.base:extend()

  session_previewer.new = function(self, o, opts, fzf_win)
    session_previewer.super.new(self, o, opts, fzf_win)
    setmetatable(self, session_previewer)
    return self
  end

  session_previewer.populate_preview_buf = function(self, entry_str)
    local tmpbuf = self:get_tmp_buffer()
    local dirman = require('neorg').modules.get_module("core.dirman")
    if not dirman then
      return
    end
    local ws_path = dirman.get_workspace(entry_str)
    if not ws_path then
      vim.api.nvim_buf_set_lines(tmpbuf, 0, -1, false, { "No workspace found" })
      self:set_preview_buf(tmpbuf)
      self.win:update_preview_scrollbar()
      return
    end
    local index_file = io.open(ws_path .. "/index.norg", "r")
    if not index_file then
      vim.api.nvim_buf_set_lines(tmpbuf, 0, -1, false, { "No index file found" })
      self:set_preview_buf(tmpbuf)
      self.win:update_preview_scrollbar()
      return
    end
    local index_content = index_file:read("*a")
    index_file:close()
    vim.api.nvim_buf_set_lines(tmpbuf, 0, -1, false, string.split(index_content, '\n'))
    self:set_preview_buf(tmpbuf)
    self.win:update_preview_scrollbar()
  end

  session_previewer.gen_winopts = function(self)
    local new_winopts = {
      wrap = false,
      number = false,
    }
    return vim.tbl_extend("force", self.winopts, new_winopts)
  end

  return session_previewer
end

local function fzf_opts()
  return {
    prompt = ' Workspaces: ',
    cwd_prompt = false,
    file_icons = false,
    git_icons = false,
    cwd_header = false,
    no_header = true,

    previewer = workspace_previewer(),
    actions = {
      ["enter"] = function(ws)
        vim.cmd('Neorg workspace ' .. ws[1])
      end
    },
  }
end

M.list_ws_fzf = function()
  local fzf = require("fzf-lua")
  local dirman = require('neorg').modules.get_module("core.dirman")
  if not dirman then
    return
  end
  local function display(fzf_cb)
    local ws = dirman.get_workspace_names()
    table.sort(ws, function(a, b)
      return string.lower(a) < string.lower(b)
    end)
    for _, w in ipairs(ws) do
      fzf_cb(w)
    end
    fzf_cb()
  end
  local opts = fzf_opts()
  fzf.fzf_exec(display, opts)
end

M.prompt_create_file_in_ws = function()
  local fname = vim.fn.input("File name: ", "", "file")
  if fname == "" then
    return
  end
  local dirman = require('neorg').modules.get_module("core.dirman")
  if not dirman then
    return
  end
  local ws = dirman.get_current_workspace()
  dirman.create_file(fname, ws[1], {})
end

return M

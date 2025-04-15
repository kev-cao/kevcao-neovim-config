---@module 'util.neorg'
--- Utility functions for Neorg

local M = {}

--- Boilerplate code to initialize a previewer with default options.
--- @return table? #Fzf session previewer
local function init_previewer()
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

  session_previewer.gen_winopts = function(self)
    local new_winopts = {
      wrap = false,
      number = false,
    }
    return vim.tbl_extend("force", self.winopts, new_winopts)
  end

  return session_previewer
end

--- Generates a previewer for viewing Neorg workspaces.
--- @return table? #Fzf session previewer
local function workspace_previewer()
  local session_previewer = init_previewer()
  if not session_previewer then
    vim.notify("Error initializing session previewer", vim.log.levels.ERROR)
    return
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
  return session_previewer
end

--- Generates a previewer for viewing files in a Neorg workspace.
--- @return table? #Fzf session previewer
local function file_previewer()
  local session_previewer = init_previewer()
  if not session_previewer then
    vim.notify("Error initializing session previewer", vim.log.levels.ERROR)
    return
  end
  --- @param self table #The session previewer instance
  --- @param entry_str string #The entry string to be previewed
  session_previewer.populate_preview_buf = function(self, entry_str)
    local tmpbuf = self:get_tmp_buffer()
    local dirman = require('neorg').modules.get_module("core.dirman")
    if not dirman then
      return
    end
    local ws = dirman.get_current_workspace()
    if not ws then
      vim.api.nvim_buf_set_lines(tmpbuf, 0, -1, false, { "No workspace found" })
      self:set_preview_buf(tmpbuf)
      self.win:update_preview_scrollbar()
      return
    end
    local ws_path = ws[2]
    local file_path = ws_path / entry_str
    local file_content = file_path:fs_read()
    vim.api.nvim_buf_set_lines(tmpbuf, 0, -1, false, string.split(file_content, '\n'))
    self:set_preview_buf(tmpbuf)
    self.win:update_preview_scrollbar()
  end
  return session_previewer
end

--- List all Neorg workspaces using fzf.
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
  fzf.fzf_exec(display, {
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
  })
end

--- Prompts the user to create a new file in the current workspace.
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

--- Lists files in the current workspace using fzf.
M.list_ws_files_fzf = function()
  local fzf = require("fzf-lua")
  local dirman = require('neorg').modules.get_module("core.dirman")
  if not dirman then
    return
  end
  local ws = dirman.get_current_workspace()
  local function display(fzf_cb)
    local files = dirman.get_norg_files(ws[1])
    if not files then
      return
    end
    local file_str = {}
    for _, f in ipairs(files) do
      local rel_path = f:relative_to(ws[2])
      if rel_path ~= nil then
        table.insert(file_str, rel_path:tostring('/'))
      end
    end
    table.sort(file_str, function(a, b)
      return string.lower(a) < string.lower(b)
    end)
    for _, f in ipairs(file_str) do
      fzf_cb(f)
    end
    fzf_cb()
  end
  fzf.fzf_exec(display, {
    prompt = ' Files: ',
    cwd_prompt = false,
    file_icons = false,
    git_icons = false,
    cwd_header = false,
    no_header = true,

    previewer = file_previewer(),
    actions = {
      ["enter"] = function(file)
        dirman.open_file(ws[1], file[1])
      end
    },
  })
end

return M

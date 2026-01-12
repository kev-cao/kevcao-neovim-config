--- @module "util.obsidian"
--- Offers utility functions for Obsidian

local config = require("util.config")

local M = {}

--- Recursively query the user for the directory they want to put a new note in.
--- @param dir string The directory to query.
--- @param cb fun(dir: string|nil) Callback function to call with the selected directory.
local function query_directory(dir, cb)
  local fs = require("plenary.scandir")
  local subdirs = {}
  for _, path in ipairs(fs.scan_dir(dir, { depth = 1, only_dirs = true })) do
    if path ~= dir then
      local subdir = path:sub(#dir + 2)
      table.insert(subdirs, subdir)
    end
  end

  if #subdirs == 0 then
    cb(dir)
    return
  end

  -- Prompt user to select a subdirectory, or the first choice to use the
  -- currrent dir.
  local choices = vim.list_extend({ "Choose current dir" }, subdirs)
  vim.ui.select(choices, {
    prompt = "Select subdirectory for new note (or choose current dir):",
  }, function(choice)
    if choice == nil then
      cb(nil)
    elseif choice == "Choose current dir" then
      cb(dir)
    else
      query_directory(dir .. "/" .. choice, cb)
    end
  end)
end

--- Prompts the user to select a template for a new note.
--- @param cb fun(template: string|nil) Callback function to call with the
--- selected template. Empty string is returned if no template, nil if aborted.
local function query_template(cb)
  local obsidian = require("obsidian")
  local fs = require("plenary.scandir")
  local template_dir = tostring(obsidian.api.templates_dir())
  local templates = {}
  for _, path in ipairs(fs.scan_dir(template_dir)) do
    local template = path:sub(#template_dir + 2)
    if not vim.endswith(template, ".md") then
      goto continue
    end
    template = template:sub(1, #template - 3)
    table.insert(templates, template)
    ::continue::
  end
  if #templates == 0 then
    cb(nil)
    return
  end

  local choices = vim.list_extend({ "No template" }, templates)
  vim.ui.select(choices, {
    prompt = "Select template for new note:",
  }, function(choice)
    if choice == nil then
      cb(nil)
    elseif choice == "No template" then
      cb("")
    else
      cb(choice)
    end
  end)
end

--- Normalizes an Obsidian note title to be a valid file name.
--- @param title string|nil The title of the note.
--- @return string The normalized note title.
function M.normalize_note_title(title)
  if title == nil then
    -- If title is nil, just set it to four random capital letters.
    title = ""
    for _ = 1, 4 do
      title = title .. string.char(math.random(65, 90))
    end
  else
    -- If title is given, transform it into valid file name.
    title = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
  end

  return title
end

--- Generates an ID for an Obsidian note.
--- @param title string The title of the note.
--- @return string The generated note ID.
function M.note_id(title)
  --- If the title is already an ID, just return it.
  if M.note_title_is_id(title) then
    return title
  end
  title = M.normalize_note_title(title)
  local ts = os.date("%Y%m%d%H%M%S", os.time())
  return title .. "-" .. tostring(ts)
end

--- Checks if a note title is already formatted like an ID.
--- @param title string The title of the note.
--- @return boolean True if the title is formatted like an ID, false otherwise.
function M.note_title_is_id(title)
  if title == nil then
    return false
  end
  local pattern = "^[a-z0-9%-]+%-"
  for _ = 1, 14 do
    pattern = pattern .. "%d"
  end
  pattern = pattern .. "$"
  return string.match(title, pattern)
end

--- Generates default aliases for an Obsidian note based on its title.
--- @param title string The title of the note.
--- @return table A table of default aliases.
function M.default_note_aliases(title)
  local aliases = {}
  local normalized = M.normalize_note_title(title)
  if normalized ~= title then
    table.insert(aliases, title)
  end
  return aliases
end

--- Creates a new Obsidian note, prompting the user for the directory and title.
--- Opens the new note in a buffer without writing it to disk yet.
--- @param opts obsidian.note.NoteOpts Options for creating the note.
--- @return nil
function M.create_new_note(opts)
  local obsidian = require("obsidian")
  local obsidian_path = config.get_local(
    "obsidian_vault_path", vim.fn.expand("~/Documents/obsidian")
  )
  local abort = function()
    vim.notify("Aborted note creation.", vim.log.levels.INFO)
  end

  local async = require("plenary.async")
  local query_dir_async = async.wrap(query_directory, 2)
  local query_template_async = async.wrap(query_template, 1)

  async.void(function()
    local template, _ = query_template_async()
    if template == nil then
      abort()
      return
    elseif template == "" then
      template = nil
    end
    local dir, _ = query_dir_async(obsidian_path)
    if dir == nil then
      abort()
      return
    end
    local title = nil
    vim.ui.input({ prompt = "Note name: " }, function(input)
      if input then
        title = input
      end
    end)
    if title == nil then
      abort()
      return
    end
    local normalized_title = M.normalize_note_title(title)

    local choice = vim.fn.confirm("Add timestamp to title?", "&Yes\n&No\n&Cancel", 3)
    if choice == 3 then
      abort()
      return
    elseif choice == 1 then
      normalized_title = M.note_id(normalized_title)
    end

    local create_opts = {
      id = normalized_title,
      title = normalized_title,
      verbatim = true,
      dir = dir,
      template = template,
      insert_frontmatter = template == nil,
      aliases = M.default_note_aliases(title),
      should_write = true,
    }
    vim.tbl_extend("keep", create_opts, opts or {})
    local note = obsidian.Note.create(create_opts)
    note:open({ sync = true })
  end)()
end


--- Computes the file path for the weekly todo note for a given date.
--- @param date string The date in "YYYY-MM-DD" format.
--- @return string The file path for the weekly todo note.
local function weekly_todo_path(date)
  local year, month, day = string.match(date, "^(%d%d%d%d)%-(%d%d)%-(%d%d)$")
  year = tonumber(year)
  month = tonumber(month)
  day = tonumber(day)
  local time = os.time({ year = year, month = month, day = day })
  local week = tostring(os.date("%Yw%V", time))
  local todo_filename = "todo-weekly-" .. week
  local obsidian_path = config.get_local(
    "obsidian_vault_path", vim.fn.expand("~/Documents/obsidian")
  )
  local todo_path = obsidian_path .. "/" .. todo_filename .. ".md"
  return todo_path
end

--- Lists all weekly todos in a Fzf picker for the window to choose from.
function M.list_weekly_todos()
  local dateutil = require("util.date")
  local obsidian = require("obsidian")
  local obsidian_path = config.get_local(
      "obsidian_vault_path", vim.fn.expand("~/Documents/obsidian")
  )
  --- List files that start with "todo-weekly-"
  local dates = {}
  local dateToFile = {}
  for _, file in ipairs(vim.fn.globpath(
    obsidian_path, "todo-weekly-*.md", false, true
  )) do
    local filename = vim.fn.fnamemodify(file, ":t:r")
    local year_week = filename:sub(#"todo-weekly-" + 1)
    local year, week = string.match(year_week, "^(%d%d%d%d)w(%d%d)$")
    year = tonumber(year)
    week = tonumber(week)
    local date = dateutil.week_to_date(year, week, "%Y-%m-%d")
    table.insert(dates, 0, date)
    dateToFile[date] = file
  end

  local fzf = require("fzf-lua")
  local builtin_previewer = require("fzf-lua.previewer.builtin")
  local todo_previewer = builtin_previewer.buffer_or_file:extend()
  function todo_previewer:new(o, opts, fzf_win)
    todo_previewer.super.new(self, o, opts, fzf_win)
    setmetatable(self, todo_previewer)
    return self
  end
  function todo_previewer:parse_entry(entry)
    return {
      path = weekly_todo_path(entry),
      line = 1,
      col = 1,
    }
  end

  fzf.fzf_exec(dates, {
    prompt = "Select Weekly Todo Date>",
    previewer = todo_previewer,
    fzf_opts = {
      ["--preview-window"] = "nohidden,down,60%",
    },
    actions = {
      ["default"] = function(selected)
        local date = selected[1]
        local note = obsidian.Note.from_file(dateToFile[date])
        note:open({ sync = true })
      end,
      ["ctrl-v"] = function(selected)
        local date = selected[1]
        local note = obsidian.Note.from_file(dateToFile[date])
        note:open({ sync = true, open_strategy = "vsplit" })
      end,
      ["ctrl-s"] = function(selected)
        local date = selected[1]
        local note = obsidian.Note.from_file(dateToFile[date])
        note:open({ sync = true, open_strategy = "hsplit" })
      end,
    }
  })
end

--- Opens the weekly todo note for the current week, creating it if it does not
--- exist.
function M.goto_or_create_todays_weekly_todo()
  local obsidian = require("obsidian")
  local obsidian_path = config.get_local(
    "obsidian_vault_path", vim.fn.expand("~/Documents/obsidian")
  )
  local todo_filename = "todo-weekly-" .. os.date("%Yw%V")
  local todo_path = obsidian_path .. "/" .. todo_filename .. ".md"
  if vim.fn.filereadable(todo_path) == 1 then
    local note = obsidian.Note.from_file(todo_path)
    note:open({ sync = true })
  else
    local note = obsidian.Note.create({
      id = todo_filename,
      title = todo_filename,
      verbatim = true,
      dir = obsidian_path,
      should_write = true,
      insert_frontmatter = false,
      template = "weekly-todo-tmpl",
    })
    note:open({ sync = true })
  end
end

return M

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
--- @param opts obsidian.CreateNoteOpts Options for creating the note.
--- @return nil
function M.create_new_note(opts)
  local client = require("obsidian").get_client()
  local obsidian_path = config.get_local(
    "obsidian_vault_path", vim.fn.expand("~/Documents/obsidian")
  )
  local aborted = function()
    vim.notify("Aborted note creation.", vim.log.levels.INFO)
  end
  query_directory(obsidian_path, function(dir)
    if dir == nil then
      aborted()
      return
    end

    local title = nil
    vim.ui.input({ prompt = "Note name: " }, function(input)
      if input then
        title = input
      end
    end)
    if title == nil then
      aborted()
      return
    end
    local normalized_title = M.normalize_note_title(title)

    local choice = vim.fn.confirm("Add timestamp to title?", "&Yes\n&No\n&Cancel", 3)
    if choice == 3 then
      vim.notify("Aborted note creation.", vim.log.levels.INFO)
      return
    elseif choice == 1 then
      normalized_title = M.note_id(normalized_title)
    end

    local create_opts = {
      title = normalized_title,
      dir = dir,
      no_write = true,
      template = "note",
    }
    vim.tbl_extend("keep", create_opts, opts or {})
    local note = client:create_note(create_opts)
    --- Have to append the aliases separately or else Obsidian.nvim adds
    --- its own.
    vim.list_extend(note.aliases, M.default_note_aliases(title))
    client:open_note(note, { sync = true })
    client:write_note_to_buffer(note, { template = create_opts.template })
  end)
end

--- Inserts the current date at the cursor position in "Month Day, Year" format.
--- @return nil
function M.insert_todays_date()
  local date_format = "%B %-e, %Y"
  local date_str = tostring(os.date(date_format))
  vim.api.nvim_put({ date_str }, "c", true, true)
end

return M

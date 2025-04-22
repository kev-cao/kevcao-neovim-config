--- @module "util.func"
--- Offers utility functions

local M = {}

function M.check_global_var(var, expected, default)
    local actual = vim.g[var]
    if actual == nil and default ~= nil then
        actual = default
    end
    return actual == expected
end

function M.is_plugin_loaded(plugin)
    return vim.tbl_get(require("lazy.core.config"), "plugins", plugin, "_", "loaded")
end

function M.get_plugin_if_loaded(plugin)
    if M.is_plugin_loaded(plugin) then
        return true, require(plugin)
    end
    return false, nil
end

function string.capitalize(str)
    if str == "" then
        return
    end
    local first = str:sub(1, 1)
    local last = str:sub(2)
    return first:upper() .. last:lower()
end

function M.current_buffer_ext_is(ext)
    return vim.bo.filetype == ext
end

--- Display text in a centered unmodifiable floating window.
--- @param txt_tbl table: Table of strings to display in the floating window.
--- @param height number: Height of the floating window.
--- @param width number: Width of the floating window.
--- @param opts table: Additional options for the floating window.
function M.display_in_float(txt_tbl, height, width, opts)
    local ui_height, ui_width = M.get_ui_dimensions()
    local buf = vim.api.nvim_create_buf(false, true)
    opts = vim.tbl_deep_extend("force", opts or {}, {
        relative = "editor",
        width = width,
        height = height,
        col = ui_width / 2 - width / 2,
        row = ui_height / 2 - height / 2,
        anchor = "NW",
        style = "minimal",
        border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
    })
    -- local box = create_box(width, height)
    local win = vim.api.nvim_open_win(buf, true, opts)
    vim.api.nvim_set_option_value("cursorline", true, { win = win })
    -- vim.api.nvim_buf_set_lines(buf, 0, -1, false, box)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, txt_tbl)
    vim.api.nvim_buf_set_keymap(buf, "n", "q", ":close<CR>", { noremap = true, silent = true, nowait = true })
    vim.api.nvim_set_option_value("readonly", true, { buf = buf })
    vim.api.nvim_set_option_value("modified", false, { buf = buf })
    vim.api.nvim_set_option_value("modifiable", false, { buf = buf })
    vim.api.nvim_set_option_value("modifiable", false, { buf = buf })
end

-- Function to get the current UI dimensions, returns height and width
function M.get_ui_dimensions()
    local h = vim.api.nvim_exec2("echo &lines", { output = true }).output
    local w = vim.api.nvim_exec2("echo &columns", { output = true }).output
    local height = tonumber(h) or 0
    local width = tonumber(w) or 0
    return height, width
end

function M.display_table(tbl, indent)
    indent = indent or 0
    local toprint = ""
    local indentStr = string.rep("  ", indent)
    for k, v in pairs(tbl) do
        local key = tostring(k)
        if type(v) == "table" then
            toprint = toprint .. indentStr .. key .. " = {\n" .. M.display_table(v, indent + 1) .. indentStr .. "}\n"
        else
            toprint = toprint .. indentStr .. key .. " = " .. tostring(v) .. "\n"
        end
    end
    return toprint
end

function string.split(str, delimiter)
    local result = {}
    local from = 1
    local delim_from, delim_to = string.find(str, delimiter, from)
    while delim_from do
        table.insert(result, string.sub(str, from, delim_from - 1))
        from = delim_to + 1
        delim_from, delim_to = string.find(str, delimiter, from)
    end
    table.insert(result, string.sub(str, from))
    return result
end

--- Creates a new which-key spec with the buffer option set to true.
--- @param specs {[number]: wk.Spec}: A list of which-key specs.
--- @return {[number]: wk.Spec}: A new list of which-key specs with the buffer option set to true.
function M.make_buflocal(specs)
    local ret = {}
    for _, spec in ipairs(specs) do
        spec = vim.deepcopy(spec)
        spec.buffer = true
        table.insert(ret, spec)
    end
    return ret
end

return M

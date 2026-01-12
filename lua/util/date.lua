--- @module "util.date"
--- Offers utility functions for date and time

local M = {}

--- Converts an ISO week date (year and week number) to a standard date string.
--- @param year number The ISO week-numbering year.
--- @param week number The ISO week number (1-53).
--- @param fmt string The format string for os.date (e.g., "%Y-%m-%d").
--- @return string The corresponding date string formatted according to fmt.
function M.week_to_date(year, week, fmt)
  -- Start with Jan 4th of the given year.
  -- The ISO 8601 standard defines week 1 as the first week that contains
  -- at least four days of the new year, which always includes Jan 4th.
  local jan4 = os.time({year = year, month = 1, day = 4, hour = 12, min = 0, sec = 0})
  local jan4_table = os.date("*t", jan4)
  -- os.date("*t").wday: Sunday is 1, Monday is 2, ..., Saturday is 7.
  -- We want Monday to be the reference point (day 2).
  local weekday_jan4 = jan4_table.wday
  if weekday_jan4 == 1 then -- If Jan 4th is Sunday, adjust for 0-indexed day logic below
    weekday_jan4 = 8
  end

  -- Calculate the number of days to subtract to get to the Monday of the week containing Jan 4th
  local days_to_monday = weekday_jan4 - 2

  -- Calculate the timestamp for the Monday of Week 1
  -- (The logic below uses 1 for wday Monday, so adjust subtraction)
  local week1_monday_timestamp = jan4 - (days_to_monday * 86400) -- 86400 seconds in a day

  -- Calculate the timestamp for the Monday of the target week
  local target_monday_timestamp = week1_monday_timestamp + ((week - 1) * 7 * 86400)

  -- Convert the final timestamp back to a readable date string (e.g., "YYYY-MM-DD")
  return tostring(os.date(fmt, target_monday_timestamp))
end

return M

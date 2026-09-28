-- PaTiGroup: saved settings and marker order, no WoW API calls (tested in tests/logic_spec.lua).
local _, ns = ...
local Logic = {}
ns.Logic = Logic

Logic.SCHEMA = 1
Logic.SLOTS = 8
Logic.SCALES = { 0.8, 0.9, 1, 1.1, 1.25, 1.5 }
Logic.NOTE_MAX = 200 -- characters of the local note

-- Raid target indices: 1 Star, 2 Circle, 3 Diamond, 4 Triangle, 5 Moon, 6 Square, 7 Cross, 8 Skull.
-- Default bar order starts with the four markers of PaTiGroup <= 0.4 (Skull, Cross, Moon, Square).
Logic.DEFAULT_MARKERS = { 8, 7, 5, 6, 4, 3, 2, 1 }

Logic.DEFAULTS = {
    locked = false,
    scale = 1,
    language = "auto",
    showPull = true,
    showGroupInfo = true,
    showNote = true,
    note = "",
}

local function copy(list)
    local result = {}
    for index, value in ipairs(list) do result[index] = value end
    return result
end

-- Fills missing values, keeps existing ones (also false). A broken marker list is replaced by the default.
function Logic.Migrate(db)
    db = db or {}
    for key, value in pairs(Logic.DEFAULTS) do
        if db[key] == nil then db[key] = value end
    end
    if type(db.markers) ~= "table" or #db.markers ~= Logic.SLOTS then db.markers = copy(Logic.DEFAULT_MARKERS) end
    db.schema = Logic.SCHEMA
    return db
end

-- "Restore Defaults": settings back, position and note kept (the note is the player's text).
function Logic.RestoreDefaults(db)
    for key, value in pairs(Logic.DEFAULTS) do
        if key ~= "note" then db[key] = value end
    end
    db.markers = copy(Logic.DEFAULT_MARKERS)
    return db
end

-- markers: 8 slots, each a raid target index or 0 (empty). Putting a marker into a slot moves it there:
-- the slot it came from gets the previous content, so no marker appears twice.
function Logic.SetSlot(markers, slot, marker)
    if marker ~= 0 then
        for index, value in ipairs(markers) do
            if value == marker and index ~= slot then markers[index] = markers[slot] end
        end
    end
    markers[slot] = marker
    return markers
end

-- The markers to show on the bar, in slot order.
function Logic.VisibleMarkers(markers)
    local visible = {}
    for _, marker in ipairs(markers) do
        if marker ~= 0 then visible[#visible + 1] = marker end
    end
    return visible
end

-- /tm lines for "Reset All": assigning each marker to yourself removes it from its old target,
-- the last line clears your own. Run as secure macrotext on a click — no character macro needed.
function Logic.ResetMacroText()
    local lines = {}
    for index = 1, 8 do lines[#lines + 1] = "/tm [@player] " .. index end
    lines[#lines + 1] = "/tm [@player] 0"
    return table.concat(lines, "\n")
end

-- Clamps and trims the local note.
function Logic.CleanNote(text)
    text = (text or ""):gsub("[\r\n]", " ")
    return text:sub(1, Logic.NOTE_MAX)
end

-- Secret-value rule (AGENTS.md §8): check readability FIRST, compare or test only afterwards.
-- isSecret is injected (issecretvalue in WoW), so these stay pure and testable.

-- The value, or nil if it is secret.
function Logic.Readable(value, isSecret)
    if isSecret(value) then return nil end
    return value
end

-- A yes/no API flag: true for true or 1 (older client APIs return 1/nil), false for anything else or secret.
function Logic.Flag(value, isSecret)
    if isSecret(value) then return false end
    return value == true or value == 1
end

-- A raid target index 1-8, or nil (no marker, unreadable or unexpected).
function Logic.MarkerIndex(value, isSecret)
    local marker = Logic.Readable(value, isSecret)
    if type(marker) == "number" and marker >= 1 and marker <= 8 then return marker end
    return nil
end

-- "TANK" | "HEALER" | "DAMAGER", or "NONE" for no, unreadable or unknown role.
function Logic.Role(value, isSecret)
    local role = Logic.Readable(value, isSecret)
    if role == "TANK" or role == "HEALER" or role == "DAMAGER" then return role end
    return "NONE"
end

-- roles: list of "TANK" | "HEALER" | "DAMAGER" | "NONE" → counts.
function Logic.CountRoles(roles)
    local counts = { TANK = 0, HEALER = 0, DAMAGER = 0, NONE = 0 }
    for _, role in ipairs(roles) do
        counts[role] = (counts[role] or 0) + 1
    end
    return counts
end

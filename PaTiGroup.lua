-- PaTiGroup: raid markers, ready check and pull timer. The player chooses a target and clicks a marker;
-- nothing is marked, bound or created automatically.
local addonName, ns = ...
local UI, L, Logic, Bar = ns.UI, ns.UI.L, ns.Logic, ns.Bar

local DB
local testMode = false
local layoutPending = false
local window = Bar.window

local function say(key, ...)
    print("|cff68caffPaTiGroup:|r " .. L[key]:format(...))
end

local function isSecret(value) return issecretvalue ~= nil and issecretvalue(value) == true end

local function addonVersion()
    local getMetadata = (C_AddOns and C_AddOns.GetAddOnMetadata) or GetAddOnMetadata
    return getMetadata and getMetadata(addonName, "Version") or "?"
end

-- Layout touches secure buttons: out of combat, otherwise after PLAYER_REGEN_ENABLED.
local function relayout()
    if not DB then return end
    layoutPending = not Bar.Layout(DB, testMode)
    Bar.Paint(testMode)
end

Bar.onNoteChanged = function(text) if DB then DB.note = text end end

-- Key bindings (Bindings.xml): names shown in WoW's key binding menu. Nothing is bound automatically.
local G = _G
G.BINDING_HEADER_PATIGROUP = "PaTiGroup"
G.BINDING_NAME_PATIGROUP_TOGGLE = L.TOGGLE
for marker = 1, 8 do
    local name = marker == 8 and "PaTiGroupQuickSkull" or "PaTiGroupBindMarker" .. marker
    G["BINDING_NAME_CLICK " .. name .. ":LeftButton"] = Bar.MarkerName(marker)
end
G["BINDING_NAME_CLICK PaTiGroupBindClear:LeftButton"] = L.CLEAR

-- Actions --------------------------------------------------------------------------------------

local function combatBlocked()
    if InCombatLockdown() then say("COMBAT_LOCKED"); return true end
    return false
end

local function setVisible(visible, quiet)
    if InCombatLockdown() then -- secure marker buttons: the bar cannot be shown/hidden in combat
        if not quiet then say("COMBAT_LOCKED") end
        return false
    end
    window:SetShown(visible)
    if not visible and not quiet then say("HIDDEN_HINT") end
    return true
end

-- Optional PaTiSuite control panel: the same rules as the commands, without chat lines (false = not possible now).
window.suiteSetShown = function(shown) return setVisible(shown, true) end

function PaTiGroup_Toggle() -- global: used by the PATIGROUP_TOGGLE key binding
    setVisible(not window:IsShown())
end

local function toggleTestMode()
    if combatBlocked() then return end
    testMode = not testMode
    relayout()
end

local function toggleCollapsed()
    if combatBlocked() then return end -- the bar holds secure buttons: no hide/resize in combat
    DB.collapsed = not DB.collapsed
    relayout()
end

local function resetPosition()
    if combatBlocked() then return end
    DB.point, DB.relativePoint, DB.x, DB.y = nil, nil, nil, nil
    window:Attach(DB, 0, -170)
end

-- Settings -------------------------------------------------------------------------------------

local modal

local function markerItems()
    local items = { { value = 0, text = "NO_MARKER" } }
    for marker = 8, 1, -1 do
        items[#items + 1] = { value = marker, text = function() return Bar.MarkerName(marker) end, icon = Bar.MarkerTexture(marker) }
    end
    return items
end

local function buildSettings()
    modal = UI.CreateModal("PaTiGroupSettings", function() return "PaTiGroup " .. L.SETTINGS end, 400)
    local function box(label, key)
        return UI.CreateCheckbox(modal, label, {
            get = function() return DB[key] end,
            set = function(value) DB[key] = value; relayout() end,
        })
    end
    modal:AddSection("GENERAL")
    modal:AddControls(box("SHOW_PULL", "showPull"), box("SHOW_GROUP_INFO", "showGroupInfo"))
    modal:AddControls(box("SHOW_NOTE", "showNote"), UI.CreateCheckbox(modal, "LOCK_WINDOW", {
        get = function() return window:IsLocked() end,
        set = function(locked) window:SetLocked(locked) end,
    }))
    modal:AddRow("LANGUAGE", UI.CreateLanguageDropdown(modal, DB, 170))
    local scales = {}
    for _, scale in ipairs(Logic.SCALES) do
        scales[#scales + 1] = { value = scale, text = function() return ("%d %%"):format(scale * 100 + 0.5) end }
    end
    modal:AddRow("SCALE", UI.CreateDropdown(modal, 170, {
        items = function() return scales end,
        get = function() return DB.scale end,
        set = function(scale)
            DB.scale = scale
            if not InCombatLockdown() then window:SetScale(scale) else layoutPending = true end
        end,
    }))
    -- Key bindings live in the WoW key binding menu (Bindings.xml); PaTiGroup never binds a key itself.
    modal:AddSection("KEYBIND_SECTION")
    modal:AddNote("KEYBIND_TITLE", "KEYBIND_PATH", "KEYBIND_TEXT", 4)
    modal:AddSection("MARKERS")
    for slot = 1, Logic.SLOTS do
        modal:AddRow(function() return L.SLOT:format(slot) end, UI.CreateDropdown(modal, 170, {
            items = markerItems,
            get = function() return DB.markers[slot] end,
            set = function(marker)
                Logic.SetSlot(DB.markers, slot, marker)
                modal:Refresh() -- another slot may have changed (marker moved)
                relayout()
            end,
        }))
    end
    UI.AddWindowSettings(modal, window) -- panel opacity + snapping (PaTiShared)
    modal:Finish(function()
        Logic.RestoreDefaults(DB)
        window:ApplyOpacity()
        UI.SetLanguage(DB.language)
        window:SetLocked(DB.locked)
        if not InCombatLockdown() then window:SetScale(DB.scale) end
        relayout()
    end)
end

local function openSettings()
    if not modal then buildSettings() end
    modal:Show()
end

-- Commands -------------------------------------------------------------------------------------

local function printDebug()
    local version, build, _, interface = GetBuildInfo()
    local keys = {}
    for _, button in ipairs(Bar.bindingButtons) do
        local key = GetBindingKey and GetBindingKey("CLICK " .. button:GetName() .. ":LeftButton")
        if key then keys[#keys + 1] = key .. "=" .. button:GetName() end
    end
    local oldMacro = GetMacroIndexByName and GetMacroIndexByName("PaTiG_Reset") or 0
    print("|cff68caffPaTiGroup Debug:|r")
    for _, line in ipairs({
        ("Addon %s %s · PaTiShared UI %s"):format(addonName, addonVersion(), tostring(UI.VERSION)),
        ("WoW %s (build %s, interface %s) · locale %s · UI language %s"):format(tostring(version), tostring(build),
            tostring(interface), GetLocale(), UI.GetLanguage()),
        ("Group %s · leader %s · assist %s · combat %s · test mode %s · layout pending %s"):format(
            (IsInRaid and IsInRaid()) and "raid" or ((IsInGroup and IsInGroup()) and "party" or "solo"),
            tostring(Logic.Readable(UnitIsGroupLeader("player"), isSecret)),
            tostring(Logic.Readable(UnitIsGroupAssistant("player"), isSecret)),
            InCombatLockdown() and "yes" or "no", testMode and "on" or "off", layoutPending and "yes" or "no"),
        ("Markers on bar: %s · key bindings: %s"):format(table.concat(Logic.VisibleMarkers(DB.markers), ","),
            #keys > 0 and table.concat(keys, ", ") or "none"),
        ("Old macro PaTiG_Reset: %s"):format(oldMacro > 0 and "present, unused since 0.5 (you may delete it)" or "not present"),
    }) do print("  " .. line) end
end

local COMMANDS = {
    [""] = PaTiGroup_Toggle, toggle = PaTiGroup_Toggle,
    show = function() setVisible(true) end, an = function() setVisible(true) end,
    hide = function() setVisible(false) end, aus = function() setVisible(false) end,
    test = toggleTestMode,
    lock = function() window:SetLocked(true) end,
    unlock = function() window:SetLocked(false) end,
    reset = resetPosition,
    settings = openSettings,
    debug = printDebug,
    version = function() say("VERSION", addonVersion()) end,
    about = function() say("ABOUT", addonVersion()) end,
    changelog = function() print("|cff68caffPaTiGroup " .. addonVersion() .. ":|r " .. L.CHANGELOG_TEXT) end,
}

SLASH_PATIGROUP1 = "/patigroup"
SLASH_PATIGROUP2 = "/pg"
SLASH_PATIGROUP3 = "/ptg"
SlashCmdList.PATIGROUP = function(message)
    local command = COMMANDS[(message or ""):match("^%s*(.-)%s*$"):lower()]
    if command and DB then command() else say("HELP") end
end

window:SetMenu(function()
    if not DB then return {} end
    local combat = InCombatLockdown()
    local combatTip = combat and "COMBAT_LOCKED" or nil
    return {
        { text = "SETTINGS", onClick = openSettings },
        { text = window:IsLocked() and "UNLOCK" or "LOCK", onClick = function() window:SetLocked(not window:IsLocked()) end },
        { text = DB.collapsed and "EXPAND" or "COLLAPSE", disabled = combat, tooltip = combatTip, onClick = toggleCollapsed },
        { text = "TEST_MODE", checked = testMode, disabled = combat, tooltip = combatTip, onClick = toggleTestMode },
        { text = "HIDE", disabled = combat, tooltip = combatTip, onClick = function() setVisible(false) end },
    }
end)

-- Events ---------------------------------------------------------------------------------------

local events = CreateFrame("Frame")
for _, event in ipairs({ "PLAYER_LOGIN", "GROUP_ROSTER_UPDATE", "PLAYER_TARGET_CHANGED", "RAID_TARGET_UPDATE",
    "PARTY_LEADER_CHANGED", "PLAYER_REGEN_ENABLED", "PLAYER_REGEN_DISABLED" }) do
    events:RegisterEvent(event)
end
pcall(events.RegisterEvent, events, "PLAYER_ROLES_ASSIGNED") -- not in every client generation

events:SetScript("OnEvent", function(_, event)
    if event == "PLAYER_LOGIN" then
        PaTiGroupDB = Logic.Migrate(PaTiGroupDB)
        DB = PaTiGroupDB
        UI.SetLanguage(DB.language)
        window:Attach(DB, 0, -170)
        if not InCombatLockdown() then window:SetScale(DB.scale) end -- /reload in combat: scale follows later
        relayout()
        local version = addonVersion()
        if DB.lastChangelog ~= version then
            if DB.lastChangelog then say("UPDATED", version) end
            DB.lastChangelog = version
        end
        say("LOADED")
    elseif not DB then
        return
    elseif event == "PLAYER_REGEN_ENABLED" and layoutPending then
        window:SetScale(DB.scale)
        relayout()
    else
        Bar.Paint(testMode) -- target, leader, roles, button states (combat-safe)
    end
end)
UI.OnLanguageChanged(function() if DB then Bar.Paint(testMode) end end)

-- PaTiLead: the bar — target line, marker buttons, actions, pull timer, group info and note.
-- Protected actions only through secure buttons with a fixed action (SetRaidTarget is protected in this
-- client); positions, visibility and attributes change only out of combat.
local _, ns = ...
local UI, L, Logic = ns.UI, ns.UI.L, ns.Logic

local Bar = {}
ns.Bar = Bar

local MARKER_TEXTURE = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_%d"
local BUTTON, GAP, PAD, LINE = 28, 4, UI.Spacing.MD, 18
local WIDTH = 2 * PAD + 9 * BUTTON + 8 * GAP -- eight markers + clear
local PULL_SECONDS = { 3, 5, 10 }

local function isSecret(value) return issecretvalue ~= nil and issecretvalue(value) == true end

function Bar.MarkerName(index) return _G["RAID_TARGET_" .. index] or L["MARKER_" .. index] end
function Bar.MarkerTexture(index) return MARKER_TEXTURE:format(index) end

local window = UI.CreateWindow("PaTiLeadMarkerBar", "PaTiLead", WIDTH, 120)
Bar.window = window

-- Secure button that sets `marker` (0 = remove) on the current target; clicked by mouse or key binding.
local function markerButton(name, parent, marker)
    local button = CreateFrame("Button", name, parent, "SecureActionButtonTemplate,BackdropTemplate")
    button:RegisterForClicks("AnyUp", "AnyDown") -- down or up, whichever ActionButtonUseKeyDown says
    button:SetAttribute("type", "raidtarget")
    button:SetAttribute("unit", "target")
    button:SetAttribute("action", "set")
    button:SetAttribute("marker", marker)
    return button
end

local function styleIconButton(button, tooltip)
    button:SetSize(BUTTON, BUTTON)
    UI.ApplyBackdrop(button, "Panel", "Border")
    button:SetScript("OnEnter", function(self) if self:IsEnabled() then self:SetBackdropBorderColor(UI.Color("Accent")) end end)
    button:SetScript("OnLeave", function(self) self:SetBackdropBorderColor(UI.Color("Border")) end)
    UI.SetTooltip(button, tooltip)
end

-- Bar buttons, one per marker (shown/ordered by the settings) plus "clear".
Bar.markerButtons = {}
for marker = 1, 8 do
    local button = markerButton("PaTiLeadMarker" .. marker, window, marker)
    styleIconButton(button, function() return { Bar.MarkerName(marker), L.MARKER_TIP } end)
    local icon = button:CreateTexture(nil, "ARTWORK")
    icon:SetSize(BUTTON - 8, BUTTON - 8)
    icon:SetPoint("CENTER")
    icon:SetTexture(Bar.MarkerTexture(marker))
    Bar.markerButtons[marker] = button
end
local clear = markerButton("PaTiLeadClear", window, 0)
styleIconButton(clear, function() return { L.CLEAR, L.CLEAR_TIP } end)
for _, degrees in ipairs({ 45, -45 }) do UI.Line(clear, 12, degrees):SetColorTexture(UI.Color("TextMuted")) end
Bar.clearButton = clear

-- Invisible buttons for WoW's key binding menu (Bindings.xml). Parent UIParent, so bindings also work while
-- the bar is hidden.
Bar.bindingButtons = {}
for marker = 1, 8 do
    local name = "PaTiLeadBindMarker" .. marker
    Bar.bindingButtons[#Bar.bindingButtons + 1] = markerButton(name, UIParent, marker)
end
Bar.bindingButtons[#Bar.bindingButtons + 1] = markerButton("PaTiLeadBindClear", UIParent, 0)
for _, button in ipairs(Bar.bindingButtons) do
    button:SetSize(1, 1)
    button:SetAlpha(0)
    button:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -1, 1)
end

-- Target line: "Target: [icon] name". The name is only handed to SetText (may be a secret value).
local targetLabel = window:CreateFontString(nil, "OVERLAY", UI.Fonts.Muted)
UI.BindText(targetLabel, "TARGET")
local targetIcon = window:CreateTexture(nil, "ARTWORK")
targetIcon:SetSize(14, 14)
targetIcon:SetPoint("LEFT", targetLabel, "RIGHT", UI.Spacing.SM, 0)
local targetName = window:CreateFontString(nil, "OVERLAY", UI.Fonts.Text)
targetName:SetPoint("LEFT", targetIcon, "RIGHT", UI.Spacing.SM, 0)
targetName:SetPoint("RIGHT", window, "RIGHT", -PAD, 0)
targetName:SetJustifyH("LEFT")
targetName:SetWordWrap(false)

-- Actions. Ready check and pull use plain API calls (not protected), leader/assist only.
local function canStartGroupAction()
    if InCombatLockdown() or not IsInGroup or not IsInGroup() then return false end
    return Logic.Flag(UnitIsGroupLeader("player"), isSecret)
        or Logic.Flag(UnitIsGroupAssistant("player"), isSecret)
end
Bar.readyCheck = UI.CreateButton(window, "READY_CHECK", nil, function()
    if not (canStartGroupAction() and DoReadyCheck) then return end
    local ok, err = pcall(DoReadyCheck)
    if not ok then Bar.lastError = tostring(err):sub(1, 120) end -- /plead debug only
end)
UI.SetTooltip(Bar.readyCheck, function() return { L.READY_CHECK, L.READY_CHECK_TIP, L.LEADER_ONLY } end)

local reset = CreateFrame("Button", "PaTiLeadReset", window, "SecureActionButtonTemplate,BackdropTemplate")
UI.StyleButton(reset, "RESET_ALL")
reset:RegisterForClicks("AnyUp", "AnyDown")
reset:SetAttribute("type", "macro")
reset:SetAttribute("macrotext", Logic.ResetMacroText())
UI.SetTooltip(reset, function() return { L.RESET_ALL, L.RESET_ALL_TIP } end)
Bar.reset = reset

Bar.pulls = {}
for index, seconds in ipairs(PULL_SECONDS) do
    local pull = UI.CreateButton(window, function() return L.PULL:format(seconds) end, 64, function()
        if not (canStartGroupAction() and C_PartyInfo and C_PartyInfo.DoCountdown) then return end
        local ok, err = pcall(C_PartyInfo.DoCountdown, seconds)
        if not ok then Bar.lastError = tostring(err):sub(1, 120) end -- /plead debug only
    end)
    UI.SetTooltip(pull, function() return { L.PULL:format(seconds), L.PULL_TIP, L.LEADER_ONLY } end)
    Bar.pulls[index] = pull
end

-- Group info: leader/assists and role counts.
local leaderLine = window:CreateFontString(nil, "OVERLAY", UI.Fonts.Text)
leaderLine:SetJustifyH("LEFT")
leaderLine:SetWordWrap(false)
local rolesLine = window:CreateFontString(nil, "OVERLAY", UI.Fonts.Muted)
rolesLine:SetJustifyH("LEFT")

-- Local note (never sent anywhere).
local note = CreateFrame("EditBox", nil, window, "BackdropTemplate")
note:SetAutoFocus(false)
note:SetFontObject(UI.Fonts.Text)
note:SetMaxLetters(Logic.NOTE_MAX)
note:SetTextInsets(UI.Spacing.SM + 2, UI.Spacing.SM, 0, 0)
UI.ApplyBackdrop(note, "Panel", "Border")
local notePlaceholder = note:CreateFontString(nil, "OVERLAY", UI.Fonts.Muted)
notePlaceholder:SetPoint("LEFT", UI.Spacing.SM + 2, 0)
UI.BindText(notePlaceholder, "NOTE_HINT")
note:SetScript("OnEscapePressed", note.ClearFocus)
note:SetScript("OnEnterPressed", note.ClearFocus)
note:SetScript("OnEditFocusGained", function() notePlaceholder:Hide() end)
note:SetScript("OnEditFocusLost", function(self) notePlaceholder:SetShown(self:GetText() == "") end)
note:SetScript("OnTextChanged", function(self, byUser)
    if byUser and Bar.onNoteChanged then Bar.onNoteChanged(Logic.CleanNote(self:GetText())) end
end)
Bar.note = note

-- Layout ---------------------------------------------------------------------------------------

-- Out of combat only: order, visibility and size of everything (secure children make the bar protected).
function Bar.Layout(db, testMode)
    if InCombatLockdown() then return false end
    -- Collapsed: only the header stays. Everything else (incl. the secure marker buttons) is hidden out of combat.
    local expanded = not db.collapsed
    Bar.collapsed = db.collapsed
    for _, region in ipairs({ targetLabel, targetName, clear, Bar.readyCheck, reset }) do region:SetShown(expanded) end
    if not expanded then
        targetIcon:Hide()
        for _, button in pairs(Bar.markerButtons) do button:Hide() end
        for _, pull in ipairs(Bar.pulls) do pull:Hide() end
        leaderLine:Hide()
        rolesLine:Hide()
        note:Hide()
        window:SetHeight(UI.Sizes.HeaderHeight)
        window:SetTestMode(testMode)
        return true
    end
    local y = UI.Sizes.HeaderHeight + UI.Spacing.SM
    local function place(frame, x)
        frame:ClearAllPoints()
        frame:SetPoint("TOPLEFT", window, "TOPLEFT", x, -y)
    end
    targetLabel:ClearAllPoints()
    targetLabel:SetPoint("LEFT", window, "TOPLEFT", PAD, -y - LINE / 2)
    y = y + LINE + UI.Spacing.SM

    local visible = Logic.VisibleMarkers(db.markers)
    for _, button in pairs(Bar.markerButtons) do button:Hide() end
    for position, marker in ipairs(visible) do
        local button = Bar.markerButtons[marker]
        place(button, PAD + (position - 1) * (BUTTON + GAP))
        button:Show()
    end
    place(clear, PAD + #visible * (BUTTON + GAP))
    for _, button in pairs(Bar.markerButtons) do button:SetEnabled(not testMode) end
    clear:SetEnabled(not testMode)
    reset:SetEnabled(not testMode)
    y = y + BUTTON + UI.Spacing.SM

    place(Bar.readyCheck, PAD)
    reset:ClearAllPoints()
    reset:SetPoint("LEFT", Bar.readyCheck, "RIGHT", GAP, 0)
    y = y + UI.Sizes.ButtonHeight + UI.Spacing.SM

    for index, pull in ipairs(Bar.pulls) do
        pull:SetShown(db.showPull)
        place(pull, PAD + (index - 1) * (64 + GAP))
    end
    if db.showPull then y = y + UI.Sizes.ButtonHeight + UI.Spacing.SM end

    leaderLine:SetShown(db.showGroupInfo)
    rolesLine:SetShown(db.showGroupInfo)
    if db.showGroupInfo then
        leaderLine:ClearAllPoints()
        leaderLine:SetPoint("TOPLEFT", window, "TOPLEFT", PAD, -y - 2)
        leaderLine:SetPoint("RIGHT", window, "RIGHT", -PAD, 0)
        rolesLine:ClearAllPoints()
        rolesLine:SetPoint("TOPLEFT", window, "TOPLEFT", PAD, -y - LINE - 2)
        y = y + 2 * LINE + UI.Spacing.SM
    end

    note:SetShown(db.showNote)
    if db.showNote then
        note:ClearAllPoints()
        note:SetPoint("TOPLEFT", window, "TOPLEFT", PAD, -y)
        note:SetSize(WIDTH - 2 * PAD, UI.Sizes.ButtonHeight)
        if not note:HasFocus() then note:SetText(db.note or "") end
        notePlaceholder:SetShown(note:GetText() == "" and not note:HasFocus())
        y = y + UI.Sizes.ButtonHeight + UI.Spacing.SM
    end
    window:SetHeight(y + PAD - UI.Spacing.SM)
    window:SetTestMode(testMode)
    return true
end

-- Content (combat-safe): target, group info, enabled state of the plain buttons.

local function groupUnits()
    local units, count = {}, GetNumGroupMembers and GetNumGroupMembers() or 0
    if IsInRaid and IsInRaid() then
        for index = 1, count do units[#units + 1] = "raid" .. index end
    elseif IsInGroup and IsInGroup() then
        units[1] = "player"
        for index = 1, count - 1 do units[#units + 1] = "party" .. index end
    end
    return units
end

local function paintGroup(testMode)
    if testMode then
        leaderLine:SetText(L.LEADER .. " " .. L.TEST_LEADER)
        rolesLine:SetText(L.ROLES:format(1, 1, 3))
        return
    end
    local units = groupUnits()
    if #units == 0 then
        leaderLine:SetText(L.SOLO)
        rolesLine:SetText("")
        return
    end
    local leader, assists, roles = nil, {}, {}
    for _, unit in ipairs(units) do
        -- Every value is checked for readability before it is tested or compared (secret-value rule).
        local name = Logic.Readable(UnitName(unit), isSecret)
        if Logic.Flag(UnitIsGroupLeader(unit), isSecret) then
            leader = name or leader
        elseif name and IsInRaid() and Logic.Flag(UnitIsGroupAssistant(unit), isSecret) then
            assists[#assists + 1] = name
        end
        roles[#roles + 1] = Logic.Role(UnitGroupRolesAssigned and UnitGroupRolesAssigned(unit), isSecret)
    end
    local text = L.LEADER .. " " .. (leader or "?")
    if #assists > 0 then text = text .. "  ·  " .. L.ASSISTS .. " " .. table.concat(assists, ", ") end
    leaderLine:SetText(text)
    local counts = Logic.CountRoles(roles)
    local rolesText = L.ROLES:format(counts.TANK, counts.HEALER, counts.DAMAGER)
    if counts.NONE > 0 then rolesText = rolesText .. " · " .. L.ROLES_UNSET:format(counts.NONE) end
    rolesLine:SetText(rolesText)
end

function Bar.Paint(testMode)
    local marker
    if testMode then
        targetName:SetText(L.TEST_TARGET)
        marker = 8
    elseif UnitExists("target") then
        targetName:SetText(UnitName("target"))
        marker = GetRaidTargetIndex and GetRaidTargetIndex("target")
    else
        targetName:SetText(L.NO_TARGET)
    end
    marker = Logic.MarkerIndex(marker, isSecret) -- readability first, then range check
    targetIcon:SetTexture(marker and Bar.MarkerTexture(marker) or nil)
    targetIcon:SetShown(marker ~= nil and not Bar.collapsed)
    paintGroup(testMode)
    local canStart = canStartGroupAction() and not testMode
    Bar.readyCheck:SetEnabled(canStart and DoReadyCheck ~= nil)
    for _, pull in ipairs(Bar.pulls) do
        pull:SetEnabled(canStart and C_PartyInfo ~= nil and C_PartyInfo.DoCountdown ~= nil)
    end
end

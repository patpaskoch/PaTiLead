-- PaTiGroup: the player chooses a target and explicitly clicks a marker.
local bar = CreateFrame("Frame", "PaTiGroupMarkerBar", UIParent, "BackdropTemplate")
bar:SetSize(240, 152)
bar:SetPoint("CENTER", UIParent, "CENTER", 0, -170)
bar:SetMovable(true)
bar:EnableMouse(true)
bar:RegisterForDrag("LeftButton")
bar:SetScript("OnDragStart", function(self)
    if not InCombatLockdown() then
        self:StartMoving()
    end
end)
bar:SetScript("OnDragStop", bar.StopMovingOrSizing)

bar:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true,
    tileSize = 16,
    edgeSize = 14,
    insets = { left = 3, right = 3, top = 3, bottom = 3 },
})
bar:SetBackdropColor(0.12, 0.10, 0.08, 0.95)
bar:SetBackdropBorderColor(0.65, 0.58, 0.42, 1)

local title = bar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
title:SetPoint("TOPLEFT", bar, "TOPLEFT", 16, -11)
title:SetText("PaTiGroup")

local function setVisible(visible)
    if InCombatLockdown() then
        print("|cff68caffPaTiGroup:|r Die Leiste kann im Kampf nicht ein- oder ausgeblendet werden.")
        return
    end
    if visible then
        bar:Show()
    else
        bar:Hide()
    end
end

local close = CreateFrame("Button", nil, bar, "UIPanelCloseButton")
close:SetSize(24, 24)
close:SetPoint("TOPRIGHT", bar, "TOPRIGHT", -2, -2)
close:SetScript("OnClick", function()
    setVisible(false)
end)

local markers = {
    { index = 8, name = "Totenkopf" },
    { index = 7, name = "Kreuz" },
    { index = 5, name = "Mond" },
    { index = 6, name = "Quadrat" },
}

for position, marker in ipairs(markers) do
    -- SetRaidTarget is protected in this client. A secure click performs the
    -- fixed action; addon Lua must not call SetRaidTarget from OnClick.
    local button = CreateFrame("Button", nil, bar, "SecureActionButtonTemplate")
    button:SetSize(48, 48)
    button:SetPoint("TOPLEFT", bar, "TOPLEFT", 15 + (position - 1) * 53, -34)
    button:RegisterForClicks("AnyUp", "AnyDown")
    button:SetAttribute("type", "raidtarget")
    button:SetAttribute("unit", "target")
    button:SetAttribute("marker", marker.index)
    button:SetAttribute("action", "set")

    -- Use WoW's normal action-button ring rather than a flat square texture.
    -- The 22px icon leaves 13px of visible padding on every side.
    button:SetNormalTexture("Interface\\Buttons\\UI-Quickslot2")
    button:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
    button:SetPushedTexture("Interface\\Buttons\\UI-Quickslot-Depress")

    local icon = button:CreateTexture(nil, "ARTWORK")
    icon:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons")
    -- The icon deliberately remains smaller than its action-button frame.
    -- This makes the gold ring visible on all four sides.
    icon:SetSize(22, 22)
    icon:SetPoint("CENTER")
    local zeroBasedIndex = marker.index - 1
    local left = (zeroBasedIndex % 4) / 4
    local top = math.floor(zeroBasedIndex / 4) / 4
    icon:SetTexCoord(left, left + 0.25, top, top + 0.25)

    button:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_TOP")
        GameTooltip:AddLine(marker.name)
        GameTooltip:AddLine("Markiert dein aktuelles Ziel per Klick.", 1, 1, 1)
        GameTooltip:Show()
    end)
    button:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
end

-- Ctrl + left mouse button marks the already selected target with a skull.
-- It is a fixed secure action; automatic marker cycling is not permitted.
local quickSkull = CreateFrame("Button", "PaTiGroupQuickSkull", bar, "SecureActionButtonTemplate")
quickSkull:SetSize(1, 1)
quickSkull:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", -1, 1)
quickSkull:SetAlpha(0)
quickSkull:RegisterForClicks("AnyUp", "AnyDown")
quickSkull:SetAttribute("type", "raidtarget")
quickSkull:SetAttribute("unit", "target")
quickSkull:SetAttribute("marker", 8)
quickSkull:SetAttribute("action", "set")

-- Reassigning each icon to the player releases it from its previous unit.
-- The final line clears the player's icon. /tm is a secure WoW macro command;
-- calling SetRaidTarget from addon Lua is blocked by this client.
local resetMacroName = "PaTiG_Reset"
local resetMacroLines = {}
for index = 1, 8 do
    resetMacroLines[#resetMacroLines + 1] = "/tm [@player] " .. index
end
resetMacroLines[#resetMacroLines + 1] = "/tm [@player] 0"
local resetMacroBody = table.concat(resetMacroLines, "\n")

local reset = CreateFrame("Button", nil, bar, "SecureActionButtonTemplate,UIPanelButtonTemplate")
reset:SetSize(94, 24)
reset:SetPoint("TOPLEFT", bar, "TOPLEFT", 128, -86)
reset:SetText("Reset All")
reset:RegisterForClicks("AnyUp", "AnyDown")
reset:SetAttribute("type", "macro")
reset:Disable()
reset:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOP")
    GameTooltip:AddLine("Alle Zielmarker entfernen")
    GameTooltip:AddLine("Ein Klick entfernt die acht Zielmarker, auch von anderen Zielen.", 1, 1, 1)
    GameTooltip:Show()
end)

local ready = CreateFrame("Button", nil, bar, "UIPanelButtonTemplate")
ready:SetSize(104, 24)
ready:SetPoint("TOPLEFT", bar, "TOPLEFT", 14, -86)
ready:SetText("Ready Check")
ready:SetScript("OnClick", function()
    if InCombatLockdown() or not DoReadyCheck then
        return
    end
    pcall(DoReadyCheck)
end)
ready:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOP")
    GameTooltip:AddLine("Ready Check")
    GameTooltip:AddLine("Startet WoWs normalen Bereitschaftscheck.", 1, 1, 1)
    GameTooltip:Show()
end)
ready:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)

local function canStartGroupAction()
    if InCombatLockdown() or not IsInGroup or not IsInGroup() then
        return false
    end
    return UnitIsGroupLeader("player") or UnitIsGroupAssistant("player")
end

local pullButtons = {}
local function startPull(seconds)
    if not canStartGroupAction() or not C_PartyInfo or not C_PartyInfo.DoCountdown then
        return
    end
    pcall(C_PartyInfo.DoCountdown, seconds)
end

for position, seconds in ipairs({ 3, 5, 10 }) do
    local pull = CreateFrame("Button", nil, bar, "UIPanelButtonTemplate")
    pull:SetSize(64, 24)
    pull:SetPoint("TOPLEFT", bar, "TOPLEFT", 14 + (position - 1) * 72, -116)
    pull:SetText("Pull " .. seconds)
    pull:SetScript("OnClick", function()
        startPull(seconds)
    end)
    pull:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_TOP")
        GameTooltip:AddLine("Pull " .. seconds)
        GameTooltip:AddLine("Startet WoWs Gruppen-Countdown.", 1, 1, 1)
        GameTooltip:Show()
    end)
    pull:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
    pullButtons[#pullButtons + 1] = pull
end

local function updateReadyCheck()
    local canStart = canStartGroupAction()
    ready:SetEnabled(canStart and DoReadyCheck ~= nil)
    for _, pull in ipairs(pullButtons) do
        pull:SetEnabled(canStart and C_PartyInfo and C_PartyInfo.DoCountdown ~= nil)
    end
end
reset:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)

function PaTiGroup_Toggle()
    setVisible(not bar:IsShown())
end

SLASH_PATIGROUP1 = "/patigroup"
SLASH_PATIGROUP2 = "/pg"
SLASH_PATIGROUP3 = "/ptg"
SlashCmdList.PATIGROUP = function(message)
    local command = (message or ""):match("^%s*(.-)%s*$"):lower()
    if command == "show" or command == "an" then
        setVisible(true)
    elseif command == "hide" or command == "aus" then
        setVisible(false)
    elseif command == "" or command == "toggle" then
        PaTiGroup_Toggle()
    else
        print("|cff68caffPaTiGroup:|r /patigroup show, /patigroup hide oder /patigroup toggle")
    end
end

local bindingSetup = CreateFrame("Frame")
bindingSetup:RegisterEvent("PLAYER_LOGIN")
bindingSetup:RegisterEvent("GROUP_ROSTER_UPDATE")
bindingSetup:RegisterEvent("PLAYER_REGEN_ENABLED")
bindingSetup:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGIN" then
        local macroIndex = GetMacroIndexByName(resetMacroName)
        if macroIndex == 0 then
            macroIndex = CreateMacro(resetMacroName, "INV_MISC_QUESTIONMARK", resetMacroBody, true)
        else
            local _, _, existingBody = GetMacroInfo(macroIndex)
            if existingBody ~= resetMacroBody then
                EditMacro(macroIndex, nil, nil, resetMacroBody)
            end
        end
        if macroIndex and macroIndex > 0 then
            reset:SetAttribute("macro", macroIndex)
            reset:Enable()
        else
            print("|cff68caffPaTiGroup:|r Reset braucht einen freien charakterspezifischen Makroplatz.")
        end

        if GetBindingAction("ALT-G") == "PATIGROUP_TOGGLE" then
            SetBinding("ALT-G")
        end
        local currentAction = GetBindingAction("CTRL-BUTTON1")
        if not currentAction or currentAction == "" then
            SetBindingClick("CTRL-BUTTON1", "PaTiGroupQuickSkull")
            print("|cff68caffPaTiGroup:|r Strg + Linksklick setzt Totenkopf auf dein aktuelles Ziel.")
        elseif currentAction ~= "CLICK PaTiGroupQuickSkull:LeftButton" then
            print("|cff68caffPaTiGroup:|r Strg + Linksklick ist bereits belegt; Schnellmarker wurde nicht gesetzt.")
        end
        SaveBindings(GetCurrentBindingSet())
    end
    updateReadyCheck()
end)

local version, build, _, interfaceVersion = GetBuildInfo()
print(string.format("|cff68caffPaTiGroup|r geladen (WoW %s, Build %s, Interface %s). /patigroup show zeigt die Leiste.", tostring(version), tostring(build), tostring(interfaceVersion)))


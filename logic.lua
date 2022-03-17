FastReset = FastReset or {}


local deathCounter = 0

local function disableAllListeners()
    EVENT_MANAGER:UnregisterForEvent(FastReset.name .. "RefillUltimate", EVENT_PLAYER_ACTIVATED)
    EVENT_MANAGER:UnregisterForEvent(FastReset.name .. "AutoPortToUltiHouse", EVENT_PLAYER_ACTIVATED)
    EVENT_MANAGER:UnregisterForEvent(FastReset.name .. "AutoResetInstance", EVENT_PLAYER_ACTIVATED)
    EVENT_MANAGER:UnregisterForEvent(FastReset.name .. "AutoPortToLeader", EVENT_PLAYER_ACTIVATED)
    EVENT_MANAGER:UnregisterForEvent(FastReset.name .. "DeathDetection", EVENT_UNIT_DEATH_STATE_CHANGED)
    EVENT_MANAGER:UnregisterForUpdate(FastReset.name .. "UltiRecharge")
    EVENT_MANAGER:UnregisterForUpdate(FastReset.name .. "LeaderInTrial")
end

local function travelToTrial()
    if FastReset.TrialZoneID == -1 then
        FastReset.debug(GetString(FASTRESET_ERROR_NO_TRIAL_SET))
        return
    end
    if FastReset.TrialZoneID == GetZoneId(GetUnitZoneIndex("player")) then
        FastReset.TrialZoneID = -1
        return
    end

    local nodeIndex = FastReset.TrialInfo[FastReset.TrialZoneID].nodeIndex
    local _, name = GetFastTravelNodeInfo(nodeIndex)

    ZO_Dialogs_ShowPlatformDialog("RECALL_CONFIRM", {nodeIndex = nodeIndex}, {mainTextParams = {FastReset.filterName(name)}})
    FastReset.TrialZoneID = -1
end

-- automatically jump to the leader when he is back in the trial zone
-- the leader straight just ports in
local function autoPortBack()
    if IsUnitGroupLeader('player') then
        travelToTrial()
        return
    end
    EVENT_MANAGER:RegisterForUpdate(FastReset.name .. "LeaderInTrial", 100, function()
        local leaderZoneID = GetZoneId(GetUnitZoneIndex(GetGroupLeaderUnitTag()))
        local playerZoneID = GetZoneId(GetUnitZoneIndex("player"))
        if playerZoneID == FastReset.TrialZoneID then
            EVENT_MANAGER:UnregisterForUpdate(FastReset.name .. "LeaderInTrial")
            FastReset.TrialZoneID = -1
            return
        end
        if leaderZoneID == FastReset.TrialZoneID then
            EVENT_MANAGER:UnregisterForUpdate(FastReset.name .. "LeaderInTrial")
            LibAddonMenu2.util.ShowConfirmationDialog(
                GetString(FASTRESET_DIALOG_PORT_TO_LEADER_TITLE),
                GetString(FASTRESET_DIALOG_PORT_TO_LEADER_TEXT), 
                function() JumpToGroupLeader() FastReset.TrialZoneID = -1 end) -- maybe more debug? d("teleporting to leader XXX")
        end
    end)
end

-- port to ulti house
function FastReset.PortToUltiHouse()
    local playerName = FastReset.savedVariables.ultiHouse.playerName
    local id = FastReset.savedVariables.ultiHouse.id

    if playerName ~= nil and playerName ~= "" then
        if id ~= nil or id ~= 0 then
            if playerName == GetDisplayName() or playerName == nil then
                RequestJumpToHouse(id)
            else
                JumpToSpecificHouse(playerName, id)
            end
        else
            JumpToHouse(playerName)
        end
        -- maybe more debug? d("teleporting to XXX's ulti-house")
    else
        FastReset.debug(FASTRESET_ERROR_NOHOUSEDEFINED)
    end
end

local function startUltiCheck()
    EVENT_MANAGER:UnregisterForEvent(FastReset.name .. "RefillUltimate", EVENT_PLAYER_ACTIVATED)

    local current, maximum = GetUnitPower("player", POWERTYPE_ULTIMATE)

    if current == maximum then
        FastReset.debug(GetString(FASTRESET_ULTIMATE_FULL))
        EVENT_MANAGER:UnregisterForUpdate(FastReset.name .. "UltiRecharge")
        autoPortBack()
    end
end

-- automatically port to ulti house
local function autoPortToUltiHouse()
    EVENT_MANAGER:UnregisterForEvent(FastReset.name .. "AutoPortToUltiHouse", EVENT_PLAYER_ACTIVATED)

    -- show dialog
    LibAddonMenu2.util.ShowConfirmationDialog(
        GetString(FASTRESET_DIALOG_PORT_TO_ULTI_HOUSE_TITLE),
        zo_strformat(GetString(FASTRESET_DIALOG_PORT_TO_ULTI_HOUSE_TEXT), FastReset.savedVariables.ultiHouse.playerName),
        function()
            zo_callLater(function()
                EVENT_MANAGER:RegisterForEvent(FastReset.name .. "RefillUltimate", EVENT_PLAYER_ACTIVATED, function()
                    EVENT_MANAGER:RegisterForUpdate(FastReset.name .. "UltiRecharge", 100, startUltiCheck)
                end)
                FastReset.PortToUltiHouse()
        end, FastReset.savedVariables.autoPortToUltiHouseDelay)
    end)
end

-- reset the instance
function FastReset.ResetInstance()
    deathCounter = 0

    if GetGroupSize() == 0 then
        FastReset.debug(GetString(FASTRESET_ERROR_NOT_IN_GROUP))
        return
    end
    if not IsUnitGroupLeader('player') then
        FastReset.debug(GetString(FASTRESET_ERROR_NOT_LEADER))
        return
    end

    FastReset.debug(GetString(FASTRESET_RESETTING_INSTANCE))
    SetVeteranDifficulty(not IsGroupUsingVeteranDifficulty())
    zo_callLater(function() SetVeteranDifficulty(not IsGroupUsingVeteranDifficulty()) end, 1000)

end

-- automatically reset the instance
local function autoResetInstance()
    EVENT_MANAGER:UnregisterForEvent(FastReset.name .. "AutoResetInstance", EVENT_PLAYER_ACTIVATED)
    zo_callLater(FastReset.ResetInstance, FastReset.savedVariables.autoResetDelay)
end

-- automatically leave the instance
function FastReset.AutoLeaveInstance()
    local isLeader = IsUnitGroupLeader('player')
    if not CanExitInstanceImmediately() then FastReset.debug(GetString(FASTRESET_ERROR_NOTININSTANCE)) return end

    -- if the player is the group leader, start AutoResetInstance handler
    if isLeader then
        EVENT_MANAGER:RegisterForEvent(FastReset.name .. "AutoResetInstance", EVENT_PLAYER_ACTIVATED, autoResetInstance)
    end

    -- create local variable to keep track if the player needs no autoportback because its handled by autoPortToUltiHouse
    local skipAutoPortBack = false
    -- if the player has ulticharging enabled, start AutoPortToUltiHouse handler
    if FastReset.savedVariables.autoPortToUltiHouseEnabled then
        -- check ulti & if ulti is allready full
        local ult1 = GetSlotBoundId(ACTION_BAR_ULTIMATE_SLOT_INDEX + 1, HOTBAR_CATEGORY_BACKUP)
        local ult2 = GetSlotBoundId(ACTION_BAR_ULTIMATE_SLOT_INDEX + 1, HOTBAR_CATEGORY_PRIMARY)

        PRIMARY_ULT_COST = GetAbilityCost(ult1)
        BACKUP_ULT_COST = GetAbilityCost(ult2)

        local ultiNeeded = math.max(PRIMARY_ULT_COST, BACKUP_ULT_COST)
        local current, maximum = GetUnitPower("player", POWERTYPE_ULTIMATE)

        -- if the ulti needs to be charged to maximum, overwrite the ultiNeeded with maximum
        if FastReset.savedVariables.autoPortToUltiHouseWithMaxUltimate then
            ultiNeeded = maximum
        end

        if current < ultiNeeded then
            EVENT_MANAGER:RegisterForEvent(FastReset.name .. "AutoPortToUltiHouse", EVENT_PLAYER_ACTIVATED, autoPortToUltiHouse) --<---------------------------------------------------------------------
            skipAutoPortBack = true
        end
    end

    if not skipAutoPortBack then
        FastReset.debug(GetString(FASTRESET_ULTIMATE_FULL_SKIP_RECHARGE))
        EVENT_MANAGER:RegisterForEvent(FastReset.name .. "AutoPortBack", EVENT_PLAYER_ACTIVATED, function()
            EVENT_MANAGER:UnregisterForEvent(FastReset.name .. "AutoPortBack", EVENT_PLAYER_ACTIVATED)
            autoPortBack()
        end)
    end

    -- use hodorreflexes when possible to exit the instance
    if HodorReflexes then
        if isLeader then
            HodorReflexes.modules.share.SendExitInstance()
            return
        end

        HodorReflexes.ExitInstance()
        return
    end

    -- legacy code - if hodor is not installed just port out

    LibAddonMenu2.util.ShowConfirmationDialog(
        GetString(FASTRESET_DIALOG_EXIT_INSTANCE_TITLE),
        GetString(FASTRESET_DIALOG_EXIT_INSTANCE_TEXT),
        function() if CanExitInstanceImmediately() then ExitInstanceImmediately() end end)
end

-- start death detection
local function startDeathDetection()
    FastReset.debug(GetString(FASTRESET_DEATHDETECTION_STARTED))

    EVENT_MANAGER:RegisterForEvent(FastReset.name .. "DeathDetection", EVENT_UNIT_DEATH_STATE_CHANGED, function(_, unitTag, isDead)
        -- filter out non death events
        if not isDead then return end
        -- filter out deaths in other zones and also ignore pets. only focus on players
        if (GetUnitZoneIndex("player") ~= GetUnitZoneIndex(unitTag)) or (not string.find(unitTag, "group")) then return end
    
        -- increase death counter
        deathCounter = deathCounter + 1
    
        -- set the TrialZone again - just to be safe
        -- FastReset.TrialZoneID = GetZoneId(GetUnitZoneIndex("player"))

        -- check the amount of deaths
        if deathCounter >= FastReset.maxDeathCount then
            EVENT_MANAGER:UnregisterForEvent(FastReset.name .. "DeathDetection", EVENT_UNIT_DEATH_STATE_CHANGED)
            FastReset.debug(GetUnitDisplayName(unitTag) .. " " .. GetString(FASTRESET_DEATHDETECTED))
            FastReset.AutoLeaveInstance()
        end
    end)
end

-- reset everything and start the death detection
local function onTrialStart(_, trialName, _)
    disableAllListeners()

    FastReset.TrialName = trialName

    if not IsUnitGrouped("player") then
        FastReset.debug(GetString(FASTRESET_ERROR_NOT_IN_GROUP))
        FastReset.debug(GetString(FASTRESET_ERROR_DEATHDETECTION_NOT_STARTED))
        return
    end
    -- check if everyone is in zone
    local zoneIndex = GetUnitZoneIndex("player")

	-- Cycle through group and check if they are in the same zone
	for i=1, GetGroupSize(), 1 do
        if GetUnitZoneIndex(GetGroupUnitTagByIndex(i)) ~= zoneIndex then
            FastReset.debug(GetString(FASTRESET_ERROR_NOT_IN_SAME_ZONE))
            FastReset.debug(GetString(FASTRESET_ERROR_DEATHDETECTION_NOT_STARTED))
            return
        end
	end

    FastReset.TrialZoneID = GetZoneId(zoneIndex)

    deathCounter = 0
    startDeathDetection()
    FastReset.debug(GetString(FASTRESET_TRIALSTARTED))
end

-- enable fastreset listener
function FastReset.enable()
    EVENT_MANAGER:UnregisterForEvent(FastReset.name .. "RaidStarted", EVENT_RAID_TRIAL_STARTED)
    disableAllListeners()

    FastReset.TrialZoneID = -1

    EVENT_MANAGER:RegisterForEvent(FastReset.name .. "RaidStarted", EVENT_RAID_TRIAL_STARTED, onTrialStart)
    FastReset.debug(GetString(FASTRESET_ENABLED))
end
-- disable fastreset listener
function FastReset.disable()
    EVENT_MANAGER:UnregisterForEvent(FastReset.name .. "RaidStarted", EVENT_RAID_TRIAL_STARTED)
    disableAllListeners()

    FastReset.TrialZoneID = -1
    
    FastReset.debug(GetString(FASTRESET_DISABLED))
end

-- toggle fast reset listerner
function FastReset.toggle()
    FastReset.savedVariables.enabled = not FastReset.savedVariables.enabled

    -- if fast reset is enabled, start listener
    if FastReset.savedVariables.enabled then
        FastReset.enable()
        return
    end

    -- otherwise disable the listener
    FastReset.disable()
end

-- donate to me if you want to
function FastReset.donate()
    -- show message window
	SCENE_MANAGER:Show('mailSend')
    -- wait 200 ms async
	zo_callLater(
		function()
            -- fill out messagebox
			ZO_MailSendToField:SetText("@m00nyONE")
			ZO_MailSendSubjectField:SetText("Donation for FastReset")
			QueueMoneyAttachment(1)
			ZO_MailSendBodyField:TakeFocus()
		end,
	200)
end

function FastReset.SetUltiHome()
    local owner =  GetCurrentHouseOwner()
    local houseID = GetCurrentZoneHouseId()
    if owner ~= nil or owner ~= "" then
        if houseID ~= 0 then
            -- TODO: check if ulti fountain is there.... but bruh this is heavy
            FastReset.savedVariables.ultiHouse.playerName = owner
            FastReset.savedVariables.ultiHouse.id = houseID
            FastReset.debug(zo_strformat(GetString(FASTRESET_MENU_SECTION_ULTIMATEAUTOMATION_INFO_HOUSE_SET), owner, FastReset.getHouseNameById(houseID)))
            return
        end
    end
    FastReset.debug(GetString(FASTRESET_MENU_SECTION_ULTIMATEAUTOMATION_ERROR_NOT_IN_HOUSE))
end
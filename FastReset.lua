FastReset = FastReset or {}
FastReset.name = "FastReset"
FastReset.color = "8B0000"
FastReset.credits = "@m00nyONE"
FastReset.version = "1.0.0"
FastReset.slashCmdShort = "/fr"
FastReset.slashCmdLong = "/fastreset"
FastReset.variableVersion = 1
FastReset.TrialZone = ""
FastReset.List = {}
FastReset.defaultVariables = {
    enabled = false,
    verboseModeEnabled = true,
    confirmLeaveInstance = true,
    autoLeaveOnDeathMaxDeaths = 1,
    autoResetDelay = 100,
    autoPortToUltiHouseDelay = 1000,
    autoPortToUltiHouseEnabled = false,
    ultiHouse = {
        playerName = "",
        id = 0
    }
}

local deathCounter = 0
local function debug(str) if FastReset.savedVariables.verboseModeEnabled then d("|c" .. FastReset.color .. "FastReset: " .. str .. "|r") end end
local function disableAllListeners()
    EVENT_MANAGER:UnregisterForEvent(FastReset.name .. "RefillUltimate", EVENT_PLAYER_ACTIVATED)
    EVENT_MANAGER:UnregisterForEvent(FastReset.name .. "AutoPortToUltiHouse", EVENT_PLAYER_ACTIVATED)
    EVENT_MANAGER:UnregisterForEvent(FastReset.name .. "AutoResetInstance", EVENT_PLAYER_ACTIVATED)
    EVENT_MANAGER:UnregisterForEvent(FastReset.name .. "AutoPortToLeader", EVENT_PLAYER_ACTIVATED)
    EVENT_MANAGER:UnregisterForEvent(FastReset.name .. "DeathDetection", EVENT_UNIT_DEATH_STATE_CHANGED)
    EVENT_MANAGER:UnregisterForUpdate(FastReset.name .. "UltiRecharge")
    EVENT_MANAGER:UnregisterForUpdate(FastReset.name .. "LeaderInTrial")
end

-- automatically jump to the leader when he is back in the trial zone
local function autoJumpToLeader()
    if IsUnitGroupLeader('player') then
        return
    end
    EVENT_MANAGER:RegisterForUpdate(FastReset.name .. "LeaderInTrial", 100, function()
        local zone = GetUnitZone(GetGroupLeaderUnitTag())
        if zone == FastReset.TrialZone then
            EVENT_MANAGER:UnregisterForUpdate(FastReset.name .. "LeaderInTrial")
            LibAddonMenu2.util.ShowConfirmationDialog(
                GetString(FASTRESET_DIALOG_PORT_TO_LEADER_TITLE),
                GetString(FASTRESET_DIALOG_PORT_TO_LEADER_TEXT),
                function() JumpToGroupLeader() end)
        end
    end)
end

-- port to ulti house
local function portToUltiHouse()
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

        zo_strformat(GetString(FASTRESET_DIALOG_PORT_TO_ULTI_HOUSE_TEXT), playerName)
    end
end

local function startUltiCheck()
    EVENT_MANAGER:UnregisterForEvent(FastReset.name .. "RefillUltimate", EVENT_PLAYER_ACTIVATED)

    local current, maximum = GetUnitPower("player", POWERTYPE_ULTIMATE)
    if current == maximum then
        debug(GetString(FASTRESET_ULTIMATE_FULL))
        EVENT_MANAGER:UnregisterForUpdate(FastReset.name .. "UltiRecharge")
        if not IsUnitGroupLeader('player') then
            autoJumpToLeader()
        end
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
                portToUltiHouse()
        end, FastReset.savedVariables.autoPortToUltiHouseDelay)
    end)
end

-- reset the instance
local function resetInstance()
    deathCounter = 0

    if GetGroupSize() == 0 then
        debug(GetString(FASTRESET_ERROR_NOT_IN_GROUP))
        return
    end
    if not IsUnitGroupLeader('player') then
        debug(GetString(FASTRESET_ERROR_NOT_LEADER))
        return
    end

    debug(GetString(FASTRESET_RESETTING_INSTANCE))
    SetVeteranDifficulty(not IsGroupUsingVeteranDifficulty())
    zo_callLater(function() SetVeteranDifficulty(not IsGroupUsingVeteranDifficulty()) end, 1000)

end

-- automatically reset the instance
local function autoResetInstance()
    EVENT_MANAGER:UnregisterForEvent(FastReset.name .. "AutoResetInstance", EVENT_PLAYER_ACTIVATED)
    zo_callLater(function() resetInstance() end, FastReset.savedVariables.autoResetDelay)
end

-- automatically leave the instance
local function autoLeaveInstance()
    local isLeader = IsUnitGroupLeader('player')

    -- if the player is the group leader, start AutoResetInstance handler
    if isLeader then
        EVENT_MANAGER:RegisterForEvent(FastReset.name .. "AutoResetInstance", EVENT_PLAYER_ACTIVATED, autoResetInstance)
    end

    -- if the player has ulticharging enabled, start AutoPortToUltiHouse handler
    if FastReset.savedVariables.autoPortToUltiHouseEnabled then
        local current, maximum = GetUnitPower("player", POWERTYPE_ULTIMATE)
        if current ~= maximum then
            EVENT_MANAGER:RegisterForEvent(FastReset.name .. "AutoPortToUltiHouse", EVENT_PLAYER_ACTIVATED, autoPortToUltiHouse)
        end
        if current == maximum and not isLeader then
            debug(GetString(FASTRESET_ULTIMATE_FULL_SKIP_RECHARGE))
            EVENT_MANAGER:RegisterForEvent(FastReset.name .. "AutoPortToLeader", EVENT_PLAYER_ACTIVATED, function()
                EVENT_MANAGER:UnregisterForEvent(FastReset.name .. "AutoPortToLeader", EVENT_PLAYER_ACTIVATED)
                autoJumpToLeader()
            end)
        end
    -- when the player is not the group leader and ulticharging is disabled, start the AutoPortToLeader handler
    else if not isLeader then
            EVENT_MANAGER:RegisterForEvent(FastReset.name .. "AutoPortToLeader", EVENT_PLAYER_ACTIVATED, function()
                EVENT_MANAGER:UnregisterForEvent(FastReset.name .. "AutoPortToLeader", EVENT_PLAYER_ACTIVATED)
                autoJumpToLeader()
            end)
        end
    end

    -- use hodorreflexes when possible to exit the instance
    if not HodorReflexes then
        if CanExitInstanceImmediately() then
            ExitInstanceImmediately()
        end
        return
    end
    HodorReflexes.modules.share.SendExitInstance()

end

-- start death detection
local function startDeathDetection()
    debug(GetString(FASTRESET_DEATHDETECTION_STARTED))
    EVENT_MANAGER:RegisterForEvent(FastReset.name .. "DeathDetection", EVENT_UNIT_DEATH_STATE_CHANGED, function(_, unitTag, isDead)
        -- filter out non death events
        if not isDead then return end
        -- filter out deaths in other zones and also ignore pets. only focus on players
        if (GetUnitZone("player") ~= GetUnitZone(unitTag)) or (not string.find(unitTag, "group")) then return end
    
        -- increase death counter
        deathCounter = deathCounter + 1
    
        -- check the amount of deaths
        if deathCounter >= FastReset.savedVariables.autoLeaveOnDeathMaxDeaths then
            EVENT_MANAGER:UnregisterForEvent(FastReset.name .. "DeathDetection", EVENT_UNIT_DEATH_STATE_CHANGED)
            debug(GetString(FASTRESET_DEATHDETECTED))
            autoLeaveInstance()
        end
    end)
end

-- reset everything and start the death detection
local function TrialStart()
    disableAllListeners()

    if not IsUnitGrouped("player") then
        debug(GetString(FASTRESET_ERROR_NOT_IN_GROUP))
        debug(GetString(FASTRESET_ERROR_DEATHDETECTION_NOT_STARTED))
        return
    end
    -- check if everyone is in zone
    local zone = GetUnitZone("player")

	-- Cycle through group and check if they are in the same zone
	for i=1, GetGroupSize(), 1 do
        if GetUnitZone(GetGroupUnitTagByIndex(i)) ~= zone then
            debug(GetString(FASTRESET_ERROR_NOT_IN_SAME_ZONE))
            debug(GetString(FASTRESET_ERROR_DEATHDETECTION_NOT_STARTED))
            return
        end
	end

    FastReset.TrialZone = zone
    deathCounter = 0
    startDeathDetection()
    debug(GetString(FASTRESET_TRIALSTARTED))
end

-- enable fastreset listener
local function enableFastReset()
    EVENT_MANAGER:UnregisterForEvent(FastReset.name .. "RaidStarted", EVENT_RAID_TRIAL_STARTED)
    disableAllListeners()
    EVENT_MANAGER:RegisterForEvent(FastReset.name .. "RaidStarted", EVENT_RAID_TRIAL_STARTED, TrialStart)
    debug(GetString(FASTRESET_ENABLED))
end
-- disable fastreset listener
local function disableFastReset()
    EVENT_MANAGER:UnregisterForEvent(FastReset.name .. "RaidStarted", EVENT_RAID_TRIAL_STARTED)
    disableAllListeners()
    debug(GetString(FASTRESET_DISABLED))
end

-- toggle fast reset listerner
function FastReset.toggleFastReset()
    FastReset.savedVariables.enabled = not FastReset.savedVariables.enabled

    -- if fast reset is enabled, start listener
    if FastReset.savedVariables.enabled then
        enableFastReset()
        return
    end

    -- otherwise disable the listener
    disableFastReset()
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

-- function to play warcry when entering /wc $NAME
local function slashCommand(str)
    if str ~= nil then
        if string.lower(str) == "leader" then
            JumpToGroupLeader()
            return
        end
        if string.lower(str) == "ulti" then
            portToUltiHouse()
            return
        end

        if string.lower(str) == "reset" then
            resetInstance()
            return
        end

        if string.lower(str) == "leave" then
            if CanExitInstanceImmediately() then
                ExitInstanceImmediately()
            end
            return
        end
    end
end

function FastReset.OnAddOnLoaded(event, addonName)
    if addonName == FastReset.name then

        -- load saved variables ( global )
        FastReset.savedVariables = FastReset.savedVariables or {}
        FastReset.savedVariables = ZO_SavedVars:NewAccountWide("FastResetVars", FastReset.variableVersion, nil, FastReset.defaultVariables, GetWorldName())

        -- create the LibAddonMenu entry
        FastReset.createMenu()

        -- start event listener when fastreset is enabled
        if FastReset.savedVariables.enabled then
            enableFastReset()
            zo_callLater(function() debug(GetString(FASTRESET_ENABLED)) end, 6000)
        end
    end
end

EVENT_MANAGER:RegisterForEvent(FastReset.name, EVENT_ADD_ON_LOADED, FastReset.OnAddOnLoaded)

--- create SLASH_COMMAND that can play every warcry available in the list
SLASH_COMMANDS[FastReset.slashCmdShort] = slashCommand
SLASH_COMMANDS[FastReset.slashCmdLong] = slashCommand
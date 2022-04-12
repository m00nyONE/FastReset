FastReset = FastReset or {}
FastReset.Shared = FastReset.Shared or {}
FastReset.Shared.needUltiPreperation = false

function FastReset.Shared.DisableAllListeners()
    -- TODO: rework to fit new Names etc
    EVENT_MANAGER:UnregisterForEvent(FastReset.name .. "KickRecieved", EVENT_PLAYER_ACTIVATED)
    EVENT_MANAGER:UnregisterForEvent(FastReset.name .. "DeathDetection", EVENT_UNIT_DEATH_STATE_CHANGED)
    EVENT_MANAGER:UnregisterForEvent(FastReset.name .. "InNewTrial", EVENT_PLAYER_ACTIVATED)
    EVENT_MANAGER:UnregisterForEvent(FastReset.name .. "AutoResetInstance", EVENT_PLAYER_ACTIVATED)
    EVENT_MANAGER:UnregisterForEvent(FastReset.name .. "RefillUltimate", EVENT_PLAYER_ACTIVATED)
    EVENT_MANAGER:UnregisterForUpdate(FastReset.name .. "LeaderInTrial")
    EVENT_MANAGER:UnregisterForUpdate(FastReset.name .. "UltiRecharge")
    EVENT_MANAGER:UnregisterForUpdate(FastReset.name .. "ReadyForPortBack")
end

-- port to ulti house
function FastReset.Shared.PortToUltiHouse()
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
    EVENT_MANAGER:RegisterForUpdate(FastReset.name .. "UltiRecharge", 100, function()
        local current, maximum = GetUnitPower("player", POWERTYPE_ULTIMATE)

        if current == maximum then
            FastReset.debug(GetString(FASTRESET_ULTIMATE_FULL))
            EVENT_MANAGER:UnregisterForUpdate(FastReset.name .. "UltiRecharge")
            FastReset.Shared.needUltiPreperation = false
        end
    end)
end

local function prepareForUlti()
    if FastReset.savedVariables.autoPortToUltiHouseEnabled then
        -- get the current, needed and maximum ultimate
        local current, ultiNeeded, maximum = FastReset.util.getUltimateCost()
        -- if the ulti needs to be charged to maximum, overwrite the ultiNeeded with maximum
        if FastReset.savedVariables.autoPortToUltiHouseWithMaxUltimate then
            ultiNeeded = maximum
        end

        -- if the ulti is lower then the needed one, trigger autoPortToUltiHouse
        if current < ultiNeeded then
            --TODO: BUGGY!!!!! if the dialog is not accepted, ReadyForPortBack timer runs forever!
            LibAddonMenu2.util.ShowConfirmationDialog(
                GetString(FASTRESET_DIALOG_PORT_TO_ULTI_HOUSE_TITLE),
                zo_strformat(GetString(FASTRESET_DIALOG_PORT_TO_ULTI_HOUSE_TEXT), FastReset.savedVariables.ultiHouse.playerName),
                function()

                    EVENT_MANAGER:RegisterForEvent(FastReset.name .. "RefillUltimate", EVENT_PLAYER_ACTIVATED, function()
                        EVENT_MANAGER:UnregisterForEvent(FastReset.name .. "RefillUltimate", EVENT_PLAYER_ACTIVATED)
                        startUltiCheck()
                    end)
                    FastReset.Shared.PortToUltiHouse()

                end)
            return true
        end
    end
    return false
end

local function portInNextTrial()
    local type = {}
    if IsUnitGroupLeader("player") then
        type = FastReset.Leader
    else
        type = FastReset.Member
    end

    type.PortBack()
end

function FastReset.Shared.PrepareForNextTrial()
    FastReset.Shared.needUltiPreperation = prepareForUlti()
    
    EVENT_MANAGER:RegisterForUpdate(FastReset.name .. "ReadyForPortBack", 100, function()
        if not FastReset.Shared.needUltiPreperation then
            EVENT_MANAGER:UnregisterForUpdate(FastReset.name .. "ReadyForPortBack")
            portInNextTrial()
        end
    end)
end

-- reset everything and start the death detection
local function onTrialStart(_, trialName, _)
    FastReset.Shared.DisableAllListeners()

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
        end
	end

    FastReset.TrialZoneID = GetZoneId(zoneIndex)

    FastReset.Share.EXITINSTANCE.VALUE = 0
    FastReset.Share.INNEWTRIAL.VALUE = 0
    FastReset.Share.DEATHCOUNT.VALUE = 0

    if IsUnitGroupLeader("player") then
        --FastReset.Leader.resetSharedValues()
        FastReset.Leader.StartDeathdetection()
        FastReset.Leader.StartSharingData()
    end

    FastReset.debug(GetString(FASTRESET_TRIALSTARTED))
end


local function leaderUpdate(_, leaderTag)
    FastReset.debug("leader changed")

    if not IsUnitGroupLeader('player') then
        EVENT_MANAGER:UnregisterForEvent(FastReset.name .. "Deathdetection", EVENT_UNIT_DEATH_STATE_CHANGED)
        FastReset.Leader.StopSharingData()
        return
    end

    if IsUnitInDungeon("player") then
        FastReset.Leader.StartDeathdetection()
    end

    FastReset.Leader.StartSharingData()
end

-- enable fastreset listener
function FastReset.enable()
    EVENT_MANAGER:UnregisterForEvent(FastReset.name .. "RaidStarted", EVENT_RAID_TRIAL_STARTED)
    FastReset.Shared.DisableAllListeners()

    EVENT_MANAGER:RegisterForEvent(FastReset.name .. "RaidStarted", EVENT_RAID_TRIAL_STARTED, onTrialStart)
    EVENT_MANAGER:RegisterForEvent(FastReset.name .. "LeaderUpdate", EVENT_LEADER_UPDATE, leaderUpdate)

    FastReset.Share:Register()
    FastReset.savedVariables.enabled = true

    FastReset.debug(GetString(FASTRESET_ENABLED))
end
-- disable fastreset listener
function FastReset.disable()
    EVENT_MANAGER:UnregisterForEvent(FastReset.name .. "RaidStarted", EVENT_RAID_TRIAL_STARTED)
    EVENT_MANAGER:UnregisterForEvent(FastReset.name .. "LeaderUpdate", EVENT_LEADER_UPDATE)
    FastReset.Shared.DisableAllListeners()
    FastReset.Leader.StopSharingData()

    FastReset.TrialZoneID = -1
    
    FastReset.Share:Unregister()
    FastReset.savedVariables.enabled = false

    FastReset.debug(GetString(FASTRESET_DISABLED))
end
-- toggle fast reset listerner
function FastReset.toggle()
    FastReset.savedVariables.enabled = not FastReset.savedVariables.enabled

    if FastReset.savedVariables.enabled then
        -- if fast reset is enabled, start listener
        FastReset.enable()
    else
        -- otherwise disable the listener
        FastReset.disable()
    end
end
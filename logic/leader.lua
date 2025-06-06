FastReset = FastReset or {}
FastReset.Leader = FastReset.Leader or {}

function FastReset.Leader.resetSharedValues()
    FastReset.Share.DEATHCOUNT.VALUE = 0
    FastReset.Share.INNEWTRIAL.VALUE = 0
    FastReset.Share.EXITINSTANCE.VALUE = 0
end

local function inNewTrial()
    FastReset.Share.INNEWTRIAL.VALUE = 1
    zo_callLater(function()
        FastReset.Share:TransmitData(true)
    end, 1000)

    --TODO: start sharing until the trial begins again
end

function FastReset.Leader.PortBack()
    if FastReset.ZoneID == -1 then
        FastReset.debug(GetString(FASTRESET_ERROR_NO_TRIAL_SET))
        return
    end

    FastReset.Shared.FastTravelBackToTrial()
    --FastReset.ZoneID = -1

    EVENT_MANAGER:RegisterForEvent(FastReset.name .. "InNewTrial", EVENT_PLAYER_ACTIVATED, function()
        -- if not in the trial, let it run until in trial
        if FastReset.ZoneID ~= GetZoneId(GetUnitZoneIndex("player")) then return end

        EVENT_MANAGER:UnregisterForEvent(FastReset.name .. "InNewTrial", EVENT_PLAYER_ACTIVATED)
        zo_callLater(inNewTrial, 1000)
        --inNewTrial()
    end)
end

local function KickPlayersAndLeave()
    LibAddonMenu2.util.ShowConfirmationDialog(
        GetString(FASTRESET_DIALOG_EXIT_INSTANCE_TITLE),
        GetString(FASTRESET_DIALOG_EXIT_INSTANCE_TEXT),
        function()
            FastReset.Share.DEATHCOUNT.VALUE = 0
            FastReset.Share.INNEWTRIAL.VALUE = 0
            FastReset.Share.EXITINSTANCE.VALUE = 1
            FastReset.Share:TransmitData(true)

            FastReset.Share.EXITINSTANCE.VALUE = 0

            -- start listener
            EVENT_MANAGER:RegisterForEvent(FastReset.name .. "KickRecieved", EVENT_PLAYER_ACTIVATED, function()
                EVENT_MANAGER:UnregisterForEvent(FastReset.name .. "KickRecieved", EVENT_PLAYER_ACTIVATED)
                FastReset.Shared.PrepareForNextTrial()
            end)

            -- exit instance after 1 sec to ensure everybody got the map pings
            zo_callLater(function()
                ExitInstanceImmediately()
            end, 1000)
        end)
end

-- reset the instance
function FastReset.Leader.ResetInstance()
    -- check if the player is in a group
    if GetGroupSize() == 0 then
        FastReset.debug(GetString(FASTRESET_ERROR_NOT_IN_GROUP))
        return
    end

    -- check if the player is the leader
    if not IsUnitGroupLeader('player') then
        FastReset.debug(GetString(FASTRESET_ERROR_NOT_LEADER))
        return
    end

    FastReset.debug(GetString(FASTRESET_RESETTING_INSTANCE))
    -- reset the instance
    SetVeteranDifficulty(not IsGroupUsingVeteranDifficulty())
    zo_callLater(function() SetVeteranDifficulty(not IsGroupUsingVeteranDifficulty()) end, 1000)
end

-- automatically reset the instance
function FastReset.Leader.AutoResetInstance()
    -- register an the EVENT_PLAYER_ACTIVATED event to trigger when the player ported out of the instance
    EVENT_MANAGER:RegisterForEvent(FastReset.name .. "AutoResetInstance", EVENT_PLAYER_ACTIVATED, function()
        -- unregister when the event has fired
        EVENT_MANAGER:UnregisterForEvent(FastReset.name .. "AutoResetInstance", EVENT_PLAYER_ACTIVATED)
        -- reset the instance with the a delay
        zo_callLater(FastReset.Leader.ResetInstance, FastReset.savedVariables.autoResetDelay)
    end)
end

-- handler to detect deaths
local function detectDeath(_, unitTag, isDead)
    -- filter out non death events
    if not isDead then return end
    -- filter out deaths in other zones and also ignore pets. only focus on players
    if (GetUnitZoneIndex("player") ~= GetUnitZoneIndex(unitTag)) or (not string.find(unitTag, "group")) then return end

    -- increase death counter
    FastReset.Share.DEATHCOUNT.VALUE = FastReset.Share.DEATHCOUNT.VALUE + 1

    FastReset.debug(GetUnitDisplayName(unitTag) .. " " .. GetString(FASTRESET_DEATHDETECTED))

    -- set the TrialZone again - just to be safe
    -- FastReset.ZoneID = GetZoneId(GetUnitZoneIndex("player"))

    -- check the amount of deaths
    if FastReset.Share.DEATHCOUNT.VALUE >= FastReset.Share.MAXDEATHCOUNT.VALUE then
        -- disbale death detection
        EVENT_MANAGER:UnregisterForEvent(FastReset.name .. "DeathDetection", EVENT_UNIT_DEATH_STATE_CHANGED)
        FastReset.ZoneID = GetZoneId(GetUnitZoneIndex("player"))
        -- reset deathCounter to 0
        FastReset.Share.DEATHCOUNT.VALUE = 0
        -- print in chat who died


        FastReset.Leader.AutoResetInstance()
        KickPlayersAndLeave()
    end
end

function FastReset.Leader.StopDeathdetection()
    EVENT_MANAGER:UnregisterForEvent(FastReset.name .. "DeathDetection", EVENT_UNIT_DEATH_STATE_CHANGED)
    --FastReset.debug("deathdetection stopped")
end

-- start death detection
function FastReset.Leader.StartDeathdetection()
    EVENT_MANAGER:RegisterForEvent(FastReset.name .. "DeathDetection", EVENT_UNIT_DEATH_STATE_CHANGED, detectDeath)
    FastReset.debug(GetString(FASTRESET_DEATHDETECTION_STARTED))
end

function FastReset.Leader.StopSharingData()
    EVENT_MANAGER:UnregisterForUpdate(FastReset.name .. "ShareData")
    FastReset.debug("sharing stopped")
end

function FastReset.Leader.StartSharingData()
    -- share every 10 seconds when able to.
    EVENT_MANAGER:RegisterForUpdate(FastReset.name .. "ShareData", FastReset.global.shareInterval, function()
        FastReset.Share:TransmitData(false)
    end)

    -- one time instant share
    FastReset.Share:TransmitData(true)
    FastReset.debug("sharing started")
end
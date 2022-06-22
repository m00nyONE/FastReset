FastReset = FastReset or {}
FastReset.Member = FastReset.Member or {}

local function checkForPortInRecieved()
    if GetZoneId(GetUnitZoneIndex("player")) == FastReset.TrialZoneID then
        --FastReset.debug("in same zone as leader. skipping port")
        EVENT_MANAGER:UnregisterForUpdate(FastReset.name .. "LeaderInTrial")
        FastReset.Share.INNEWTRIAL.VALUE = 0
        FastReset.TrialZoneID = -1
        return
    end

    if FastReset.savedVariables.speedyMode then
        FastReset.Shared.FastTravelBackToTrial()
        return
    end

    if FastReset.Share.INNEWTRIAL.VALUE == 0 then return end

    EVENT_MANAGER:UnregisterForUpdate(FastReset.name .. "LeaderInTrial")
    LibAddonMenu2.util.ShowConfirmationDialog(
        GetString(FASTRESET_DIALOG_PORT_TO_LEADER_TITLE),
        GetString(FASTRESET_DIALOG_PORT_TO_LEADER_TEXT),
        function() JumpToGroupLeader() FastReset.TrialZoneID = -1 end)
end

function FastReset.Member.PortBack()
    EVENT_MANAGER:RegisterForUpdate(FastReset.name .. "LeaderInTrial", 100, checkForPortInRecieved)
end

local function exitAndPrepare()
    -- start listener
    EVENT_MANAGER:RegisterForEvent(FastReset.name .. "KickRecieved", EVENT_PLAYER_ACTIVATED, function()
        EVENT_MANAGER:UnregisterForEvent(FastReset.name .. "KickRecieved", EVENT_PLAYER_ACTIVATED)
        -- call FastReset.Shared.PrepareForNextTrial() 1000ms later to ensure ESO has loaded all API function regarding skillcosts & ultimatepoints
        zo_callLater(FastReset.Shared.PrepareForNextTrial, 1000)
    end)
    --Kick player out of the instance
    ExitInstanceImmediately()
end

function FastReset.Member.KickRecieved()
    -- check if player is really in an instance
    if not CanExitInstanceImmediately() then FastReset.debug(GetString(FASTRESET_ERROR_NOTININSTANCE)) return end

    FastReset.TrialZoneID = GetZoneId(GetUnitZoneIndex("player"))

    if FastReset.savedVariables.confirmExit then
        LibAddonMenu2.util.ShowConfirmationDialog(
                GetString(FASTRESET_DIALOG_EXIT_INSTANCE_TITLE),
                GetString(FASTRESET_DIALOG_EXIT_INSTANCE_TEXT),
                exitAndPrepare)
    else
        exitAndPrepare()
    end
end
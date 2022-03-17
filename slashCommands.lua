FastReset = FastReset or {}
FastReset.slashCmdShort = "/fr"
FastReset.slashCmdLong = "/fastreset"

local function debug()

end

local function setMaxDeaths(str)
    if str == nil then
        FastReset.debug(GetString(FASTRESET_SLASHCOMMAND_SET_DEATHS_ERROR_MISSING_ARGUMENT))
        return
    end

    local num = tonumber(str)
    if num == "fail" then
        FastReset.debug(GetString(FASTRESET_SLASHCOMMAND_SET_DEATHS_ERROR_OUTOFRANGE))
        return
    end
    if num < 1 or num > 48 then
        FastReset.debug(GetString(FASTRESET_SLASHCOMMAND_SET_DEATHS_ERROR_OUTOFRANGE))
        return
    end

    FastReset.maxDeathCount = num
    FastReset.debug(zo_strformat(GetString(FASTRESET_SLASHCOMMAND_SET_DEATHS_MSG_SUCCESS), num))
    
end

-- create slash commands for faster access via chat
local LSC = LibSlashCommander
if LSC then
    local mainCommand = LSC:Register({FastReset.slashCmdShort, FastReset.slashCmdLong}, function() FastReset.TrialZone = GetUnitZone("player") FastReset.AutoLeaveInstance() end, GetString(FASTRESET_SLASHCOMMAND_DESCRIPTION))

    local enableCommand = mainCommand:RegisterSubCommand()
    enableCommand:AddAlias("enable")
    enableCommand:SetCallback(FastReset.enable)
    enableCommand:SetDescription(GetString(FASTRESET_SLASHCOMMAND_ENABLE_DESCRIPTION))

    local disableCommand = mainCommand:RegisterSubCommand()
    disableCommand:AddAlias("disable")
    disableCommand:SetCallback(FastReset.disable)
    disableCommand:SetDescription(GetString(FASTRESET_SLASHCOMMAND_DISABLE_DESCRIPTION))

    local ultiCommand = mainCommand:RegisterSubCommand()
    ultiCommand:AddAlias("ulti")
    ultiCommand:SetCallback(FastReset.PortToUltiHouse)
    ultiCommand:SetDescription(GetString(FASTRESET_SLASHCOMMAND_ULTI_DESCRIPTION))

    local leaderCommand = mainCommand:RegisterSubCommand()
    leaderCommand:AddAlias("leader")
    leaderCommand:SetCallback(JumpToGroupLeader)
    leaderCommand:SetDescription(GetString(FASTRESET_SLASHCOMMAND_LEADER_DESCRIPTION))

    local leaveCommand = mainCommand:RegisterSubCommand()
    leaveCommand:AddAlias("leave")
    leaveCommand:SetCallback(function() if CanExitInstanceImmediately() then ExitInstanceImmediately() end end)
    leaveCommand:SetDescription(GetString(FASTRESET_SLASHCOMMAND_LEAVE_DESCRIPTION))

    local resetCommand = mainCommand:RegisterSubCommand()
    resetCommand:AddAlias("reset")
    resetCommand:SetCallback(FastReset.ResetInstance)
    resetCommand:SetDescription(GetString(FASTRESET_SLASHCOMMAND_RESET_DESCRIPTION))

    local setCommand = mainCommand:RegisterSubCommand()
    setCommand:AddAlias("set")
    setCommand:SetCallback(function() FastReset.debug(GetString(FASTRESET_SLASHCOMMAND_SET_ERROR_NOVALUE)) end)
    setCommand:SetDescription(GetString(FASTRESET_SLASHCOMMAND_SET_DESCRIPTION))

        local setUltiHouseCommand = setCommand:RegisterSubCommand()
        setUltiHouseCommand:AddAlias("ulti")
        setUltiHouseCommand:SetCallback(FastReset.SetUltiHome)
        setUltiHouseCommand:SetDescription(GetString(FASTRESET_MENU_SECTION_ULTIMATEAUTOMATION_BUTTON_SETHOUSE_TOOLTIP))

        local setMaxDeathsCommand = setCommand:RegisterSubCommand()
        setMaxDeathsCommand:AddAlias("deaths")
        setMaxDeathsCommand:SetCallback(setMaxDeaths)
        setMaxDeathsCommand:SetDescription(GetString(FASTRESET_SLASHCOMMAND_SET_DEATHS_DESCRIPTION))
    

----------------------- DBG ------------------------------
--[[
        local debugCommand = mainCommand:RegisterSubCommand()
        debugCommand:AddAlias("debug")
        debugCommand:SetCallback(debug)
        debugCommand:SetDescription("debug")
]]--
end
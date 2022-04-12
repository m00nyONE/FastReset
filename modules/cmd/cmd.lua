FastReset = FastReset or {}
FastReset.cmd = FastReset.cmd or {}
FastReset.cmd.shortCommand = "/fr"
FastReset.cmd.longCommand = "/fastreset"
FastReset.cmd.Commands = {}

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
    if num < 1 or num > 63 then
        FastReset.debug(GetString(FASTRESET_SLASHCOMMAND_SET_DEATHS_ERROR_OUTOFRANGE))
        return
    end

    FastReset.Share.MAXDEATHCOUNT.VALUE = num
    FastReset.debug(zo_strformat(GetString(FASTRESET_SLASHCOMMAND_SET_DEATHS_MSG_SUCCESS), num))

end

local function mainCommand()
    if not CanExitInstanceImmediately() then FastReset.debug(GetString(FASTRESET_ERROR_NOTININSTANCE)) return end
    if IsUnitGroupLeader("player") then
        FastReset.Leader.AutoResetInstance()
    end

    EVENT_MANAGER:RegisterForEvent(FastReset.name .. "KickRecieved", EVENT_PLAYER_ACTIVATED, function()
        EVENT_MANAGER:UnregisterForEvent(FastReset.name .. "KickRecieved", EVENT_PLAYER_ACTIVATED)

        if FastReset.savedVariables.autoPortToUltiHouseEnabled then
            -- get the current, needed and maximum ultimate
            local current, ultiNeeded, maximum = FastReset.util.getUltimateCost()
            -- if the ulti needs to be charged to maximum, overwrite the ultiNeeded with maximum
            if FastReset.savedVariables.autoPortToUltiHouseWithMaxUltimate then
                ultiNeeded = maximum
            end

            if current < ultiNeeded then
                LibAddonMenu2.util.ShowConfirmationDialog(
                    GetString(FASTRESET_DIALOG_PORT_TO_ULTI_HOUSE_TITLE),
                    zo_strformat(GetString(FASTRESET_DIALOG_PORT_TO_ULTI_HOUSE_TEXT), FastReset.savedVariables.ultiHouse.playerName),
                    function()
                        FastReset.Shared.PortToUltiHouse()
                    end)
            end
        end
    end)

    ExitInstanceImmediately()
end

local cmd = FastReset.cmd
local commands = cmd.Commands
local LSC = LibSlashCommander

function FastReset.cmd.createSlashCommands()


    commands.main = LSC:Register({cmd.shortCommand, cmd.longCommand}, mainCommand, GetString(FASTRESET_SLASHCOMMAND_DESCRIPTION))

    commands.enable = commands.main:RegisterSubCommand()
    commands.enable:AddAlias("enable")
    commands.enable:SetCallback(FastReset.enable)
    commands.enable:SetDescription(GetString(FASTRESET_SLASHCOMMAND_ENABLE_DESCRIPTION))

    commands.disable = commands.main:RegisterSubCommand()
    commands.disable:AddAlias("disable")
    commands.disable:SetCallback(FastReset.disable)
    commands.disable:SetDescription(GetString(FASTRESET_SLASHCOMMAND_DISABLE_DESCRIPTION))

    commands.ulti = commands.main:RegisterSubCommand()
    commands.ulti:AddAlias("ulti")
    commands.ulti:SetCallback(FastReset.Shared.PortToUltiHouse)
    commands.ulti:SetDescription(GetString(FASTRESET_SLASHCOMMAND_ULTI_DESCRIPTION))

    commands.leader = commands.main:RegisterSubCommand()
    commands.leader:AddAlias("leader")
    commands.leader:SetCallback(JumpToGroupLeader)
    commands.leader:SetDescription(GetString(FASTRESET_SLASHCOMMAND_LEADER_DESCRIPTION))

    commands.leave = commands.main:RegisterSubCommand()
    commands.leave:AddAlias("leave")
    commands.leave:SetCallback(function() if CanExitInstanceImmediately() then ExitInstanceImmediately() end end)
    commands.leave:SetDescription(GetString(FASTRESET_SLASHCOMMAND_LEAVE_DESCRIPTION))

    commands.reset = commands.main:RegisterSubCommand()
    commands.reset:AddAlias("reset")
    commands.reset:SetCallback(FastReset.Leader.ResetInstance)
    commands.reset:SetDescription(GetString(FASTRESET_SLASHCOMMAND_RESET_DESCRIPTION))

    commands.set = commands.main:RegisterSubCommand()
    commands.set:AddAlias("set")
    commands.set:SetCallback(function() FastReset.debug(GetString(FASTRESET_SLASHCOMMAND_SET_ERROR_NOVALUE)) end)
    commands.set:SetDescription(GetString(FASTRESET_SLASHCOMMAND_SET_DESCRIPTION))

    commands.setUltiHouse = commands.set:RegisterSubCommand()
    commands.setUltiHouse:AddAlias("ulti")
    commands.setUltiHouse:SetCallback(FastReset.SetUltiHome)
    commands.setUltiHouse:SetDescription(GetString(FASTRESET_MENU_SECTION_ULTIMATEAUTOMATION_BUTTON_SETHOUSE_TOOLTIP))

    commands.setMaxDeaths = commands.set:RegisterSubCommand()
    commands.setMaxDeaths:AddAlias("deaths")
    commands.setMaxDeaths:SetCallback(setMaxDeaths)
    commands.setMaxDeaths:SetDescription(GetString(FASTRESET_SLASHCOMMAND_SET_DEATHS_DESCRIPTION))


    ----------------------- DBG ------------------------------
    --[[
            local debugCommand = mainCommand:RegisterSubCommand()
            debugCommand:AddAlias("debug")
            debugCommand:SetCallback(debug)
            debugCommand:SetDescription("debug")
    ]]--
end
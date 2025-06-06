--local addon = {
--    name = "FastReset",
--    version = "dev",
--
--    sv = {},
--    svName = "FastResetVars",
--    svVersion = 1,
--    svDefaults = {
--        enabled = false,
--        verboseModeEnabled = true,
--        speedyMode = false,
--        autoResetDelay = 1000,
--        autoPortToUltiHouseDelay = 1000,
--        autoPortToUltiHouseEnabled = false,
--        autoPortToUltiHouseWithMaxUltimate = false,
--        saveLastPosition = true,
--        confirmExit = false,
--        maxDeathCount = 1,
--        ultiHouse = {
--            playerName = "@No4Sniper2k3",
--            id = 46
--        },
--        enableExperimentalFeatures = false,
--    }
--}
--
--local addon_name = addon.name
--local addon_version = addon.version
--_G[addon_name] = addon
--
--local EM = EVENT_MANAGER
--
--local modules = {}
--
--function addon:RegisterModule(module)
--
--end
--
--local function onAddonLoaded(_, addonName)
--    if addonName ~= addon.name then return end
--
--    EM:UnregisterForEvent(addon.name, EVENT_ADD_ON_LOADED)
--
--    -- load savedVariables
--    addon.sv = ZO_SavedVars:NewAccountWide(addon.svName, addon.svVersion, nil, addon.svDefaults, GetWorldName())
--
--    -- if no ult house is set, use the default one provided by FastReset
--    if addon.sv.ultiHouse.playerName == "" or addon.sv.ultiHouse.id == 0 then
--        addon.sv.ultiHouse = addon.svDefaults.ultiHouse
--    end
--
--    initModules()
--    addon.RegisterModule = nil
--
--end
--
--EM:RegisterForEvent(addon.name, EVENT_ADD_ON_LOADED, onAddonLoaded)
--
--

local FR = {
    name = "FastReset",
    version = "dev"
}

FastReset.version = FR.version

function FastReset.OnAddOnLoaded(event, addonName)
    if addonName == FastReset.name then
        EVENT_MANAGER:UnregisterForEvent(FastReset.name, EVENT_ADD_ON_LOADED)

        -- load saved variables ( global )
        FastReset.savedVariables = FastReset.savedVariables or {}
        FastReset.savedVariables = ZO_SavedVars:NewAccountWide("FastResetVars", FastReset.variableVersion, nil, FastReset.defaultVariables, GetWorldName())

        if FastReset.savedVariables.ultiHouse.playerName == "" or FastReset.savedVariables.ultiHouse.id == 0 then
            FastReset.savedVariables.ultiHouse = FastReset.defaultUltiHouse
        end

        if FastReset.savedVariables.saveLastPosition then
            -- disable listener & enable listener on the fly
            FastReset.trackLastZone(true)
        end

        FastReset.cmd.createSlashCommands()
        -- create the LibAddonMenu entry
        FastReset.menu.createAddonMenu()

        FastReset.Share:Register()

        -- start event listener when fastreset is enabled
        if FastReset.savedVariables.enabled then
            FastReset.enable()
            zo_callLater(function() FastReset.debug(GetString(FASTRESET_ENABLED)) end, 6000)
        end
    end
end

EVENT_MANAGER:RegisterForEvent(FastReset.name, EVENT_ADD_ON_LOADED, FastReset.OnAddOnLoaded)
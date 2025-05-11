FastReset = FastReset or {
    version = "dev"
}

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

        -- start event listener when fastreset is enabled
        if FastReset.savedVariables.enabled then
            FastReset.enable()
            zo_callLater(function() FastReset.debug(GetString(FASTRESET_ENABLED)) end, 6000)
        end
    end
end

EVENT_MANAGER:RegisterForEvent(FastReset.name, EVENT_ADD_ON_LOADED, FastReset.OnAddOnLoaded)
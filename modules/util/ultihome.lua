FastReset = FastReset or {}

--local defaultUltiHouse = {
--    playerName = "@No4Sniper2k3",
--    id = 46
--}

local function setUltiHome(owner, houseID)
    if owner ~= nil or owner ~= "" then
        if houseID ~= 0 then
            FastReset.savedVariables.ultiHouse.playerName = owner
            FastReset.savedVariables.ultiHouse.id = houseID
            FastReset.debug(zo_strformat(GetString(FASTRESET_MENU_SECTION_ULTIMATEAUTOMATION_INFO_HOUSE_SET), owner, FastReset.util.getHouseNameById(houseID)))
            return
        end
        FastReset.debug("ERROR: setUltiHome() houseID can not be 0")
    end
    FastReset.debug("ERROR: setUltiHome() owner must not be nil or empty")
end

function FastReset.SetUltiHome()
    local owner =  GetCurrentHouseOwner()
    local houseID = GetCurrentZoneHouseId()
    if houseID == 0 then FastReset.debug(GetString(FASTRESET_MENU_SECTION_ULTIMATEAUTOMATION_ERROR_NOT_IN_HOUSE)) return end

    setUltiHome(owner, houseID)
end
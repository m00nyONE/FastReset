FastReset = FastReset or {}
local LAM2 = LibAddonMenu2

local function debug(str) if FastReset.savedVariables.verboseModeEnabled then d("|c" .. FastReset.color .. "FastReset: " .. str .. "|r") end end
local function GetHouseNameById(id) if id == 0 then return "Kein Haus" end local h = GetCollectibleName(GetCollectibleIdForHouse(id)) local i, j = string.find(h, "%^") return string.sub(h, 1, i-1) end

-- create a custom menu by using LibCustomMenu
function FastReset.createMenu()
    local panelData = {
        type = "panel",
        name = "FastReset",
        displayName = "FastReset",
        author = "|cFFC0CBm00ny|r",
        version = FastReset.version,
        website = "https://github.com/m00nyONE/FastReset",
        feedback = "https://www.esoui.com/downloads/info3257-FastReset.html#comments",
        donation = FastReset.donate,
        slashCommand = "/frsettings",
        registerForRefresh = true,
        registerForDefaults = true,
    }
    
    local optionsTable = {
        [1] = {
            type = "header",
            name = GetString(FASTRESET_MENU_SECTION_GENERAL),
            width = "full",
        },
        [2] = {
            type = "checkbox",
            name = GetString(FASTRESET_MENU_CHECKBOX_FASTRESET_TITLE),
            tooltip = GetString(FASTRESET_MENU_CHECKBOX_FASTRESET_TOOLTIP),
            getFunc = function() return FastReset.savedVariables.enabled end,
            setFunc = function(value) FastReset.toggleFastReset() end,
            width = "full",
            default = true,
        },
        [3] = {
            type = "checkbox",
            name = GetString(FASTRESET_MENU_CHECKBOX_VERBOSEMODE_TITLE),
            tooltip = GetString(FASTRESET_MENU_CHECKBOX_VERBOSEMODE_TOOLTIP),
            getFunc = function() return FastReset.savedVariables.verboseModeEnabled end,
            setFunc = function(value) FastReset.savedVariables.verboseModeEnabled = value end,
            width = "full",
            default = true,
        },
        [4] = {
            type = "slider",
            name = GetString(FASTRESET_MENU_SLIDER_DEATHS_TITLE),
            tooltip = GetString(FASTRESET_MENU_SLIDER_DEATHS_TOOLTIP),
            getFunc = function() return FastReset.savedVariables.autoLeaveOnDeathMaxDeaths end,
            setFunc = function(value) FastReset.autoLeaveOnDeathMaxDeaths = value end,
            width = "full",
            step = 1,
            decimals = 0,
            min = 1,
            max = 12,
            disabled = true,
            default = 1,
        },
        [5] = {
            type = "header",
            name = GetString(FASTRESET_MENU_SECTION_OPTIONS),
            width = "full",
        },
        -- ulti house section
        [6] = {
            type = "checkbox",
            name = GetString(FASTRESET_MENU_CHECKBOX_ULTIHOUSE_TITLE),
            tooltip = GetString(FASTRESET_MENU_CHECKBOX_ULTIHOUSE_TOOLTIP),
            getFunc = function() return FastReset.savedVariables.autoPortToUltiHouseEnabled end,
            setFunc = function(value) FastReset.savedVariables.autoPortToUltiHouseEnabled = not FastReset.savedVariables.autoPortToUltiHouseEnabled end,
            width = "full",
            disabled = function()
                if FastReset.savedVariables.ultiHouse.playerName == nil or FastReset.savedVariables.ultiHouse.playerName == "" then return true end
                if FastReset.savedVariables.ultiHouse.id == nil or FastReset.savedVariables.ultiHouse.id == 0 then return true end
                return false
            end,
            default = false,
        },
        [7] = {
            type = "description",
            text = function()
                if FastReset.savedVariables.ultiHouse.id ~= 0 then
                    return FastReset.savedVariables.ultiHouse.playerName .. "'s " .. GetHouseNameById(FastReset.savedVariables.ultiHouse.id)
                end
                return GetString(FASTRESET_MENU_DESCRIPTION_ULTIHOUSE_NOT_SET)
            end,
            width = "half",
        },
        [8] = {
            type = "button",
            name = GetString(FASTRESET_MENU_BUTTON_SETHOUSE_TITLE),
            tooltip = GetString(FASTRESET_MENU_BUTTON_SETHOUSE_TOOLTIP),
            func = function()
                local owner =  GetCurrentHouseOwner()
                local houseID = GetCurrentZoneHouseId()
                if owner ~= nil or owner ~= "" then
                    if houseID ~= 0 then
                        FastReset.savedVariables.ultiHouse.playerName = owner
                        FastReset.savedVariables.ultiHouse.id = houseID
                        debug(zo_strformat(GetString(FASTRESET_MENU_INFO_HOUSE_SET), owner, GetHouseNameById(houseID)))
                        return
                    end
                end
                debug(GetString(FASTRESET_MENU_ERROR_NOT_IN_HOUSE))
            end,
            width = "half",
            disabled = false,
        }
    }

    LAM2:RegisterAddonPanel("FastResetMenu", panelData)
    LAM2:RegisterOptionControls("FastResetMenu", optionsTable)
end
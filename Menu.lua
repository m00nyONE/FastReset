FastReset = FastReset or {}
local LAM2 = LibAddonMenu2

-- create a custom menu by using LibCustomMenu
function FastReset.createAddonMenu()
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
            type = "description",
            text = "|cff6600" .. GetString(FASTRESET_MENU_DESCRIPTION) .. "|r",
            width = "full",
        },
        [2] = {
            type = "header",
            name = GetString(FASTRESET_MENU_SECTION_GENERAL),
            width = "full",
        },
        --TODO: PUT A WARNINGT THAT YOU NEED TO MANUALLY DISABLE THIS AFTER THE RAID ENDED
        [3] = {
            type = "checkbox",
            name = GetString(FASTRESET_MENU_SECTION_GENERAL_CHECKBOX_ENABLE_TITLE),
            tooltip = GetString(FASTRESET_SECTION_GENERAL_MENU_CHECKBOX_ENABLE_TOOLTIP),
            getFunc = function() return FastReset.savedVariables.enabled end,
            setFunc = function(value) FastReset.toggle() end,
            width = "full",
            default = true,
        },
        [4] = {
            type = "checkbox",
            name = GetString(FASTRESET_MENU_SECTION_GENERAL_CHECKBOX_VERBOSEMODE_TITLE),
            tooltip = GetString(FASTRESET_MENU_SECTION_GENERAL_CHECKBOX_VERBOSEMODE_TOOLTIP),
            getFunc = function() return FastReset.savedVariables.verboseModeEnabled end,
            setFunc = function(value) FastReset.savedVariables.verboseModeEnabled = value end,
            width = "full",
            default = true,
        },
--[[
        [5] = {
            type = "checkbox",
            name = GetString(FASTRESET_MENU_SECTION_GENERAL_CHECKBOX_EXPERIMENTAL_TITLE),
            tooltip = GetString(FASTRESET_MENU_SECTION_GENERAL_CHECKBOX_EXPERIMENTAL_TOOLTIP),
            getFunc = function() return FastReset.savedVariables.enableExperimentalFeatures end,
            setFunc = function(value) FastReset.savedVariables.enableExperimentalFeatures = value end,
            width = "full",
            default = false,
        },
]]--
        [5] = {
            type = "submenu",
            name = GetString(FASTRESET_MENU_SECTION_ULTIMATEAUTOMATION),
            tooltip = GetString(FASTRESET_MENU_SECTION_ULTIMATEAUTOMATION_TOOLTIP),
            controls = {
                -- ulti house section
                --[[
                [1] = {
                    type = "description",
                    text = "|cff6600 " .. GetString(FASTRESET_MENU_SECTION_ULTIMATEAUTOMATION_DESCRIPTION) .. "|r",
                    width = "full",
                },
                ]]--
                [1] = {
                    type = "checkbox",
                    name = GetString(FASTRESET_MENU_SECTION_ULTIMATEAUTOMATION_CHECKBOX_PORTTOULTIHOUSE_TITLE),
                    tooltip = GetString(FASTRESET_MENU_SECTION_ULTIMATEAUTOMATION_CHECKBOX_PORTTOULTIHOUSE_TOOLTIP),
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
                [2] = {
                    type = "checkbox",
                    name = GetString(FASTRESET_MENU_SECTION_ULTIMATEAUTOMATION_CHECKBOX_PORTTOULTIHOUSEWHENNOT500_TITLE),
                    tooltip = GetString(FASTRESET_MENU_SECTION_ULTIMATEAUTOMATION_CHECKBOX_PORTTOULTIHOUSEWHENNOT500_TOOLTIP),
                    getFunc = function() return FastReset.savedVariables.autoPortToUltiHouseWithMaxUltimate end,
                    setFunc = function(value) FastReset.savedVariables.autoPortToUltiHouseWithMaxUltimate = not FastReset.savedVariables.autoPortToUltiHouseWithMaxUltimate end,
                    width = "full",
                    disabled = function()
                        if FastReset.savedVariables.autoPortToUltiHouseEnabled then return false end
                        return true
                    end,
                    default = false,
                },
                [3] = {
                    type = "description",
                    text = function()
                        if FastReset.savedVariables.ultiHouse.id ~= 0 then
                            return FastReset.savedVariables.ultiHouse.playerName .. "'s " .. FastReset.getHouseNameById(FastReset.savedVariables.ultiHouse.id)
                        end
                        return GetString(FASTRESET_MENU_SECTION_ULTIMATEAUTOMATION_DESCRIPTION_ULTIHOUSE_NOT_SET)
                    end,
                    width = "half",
                },
                [4] = {
                    type = "button",
                    name = GetString(FASTRESET_MENU_SECTION_ULTIMATEAUTOMATION_BUTTON_SETHOUSE_TITLE),
                    tooltip = GetString(FASTRESET_MENU_SECTION_ULTIMATEAUTOMATION_BUTTON_SETHOUSE_TOOLTIP),
                    func = FastReset.SetUltiHome,
                    width = "half",
                    disabled = false,
                },
                [5] = {
                    type = "divider"
                },
                [6] = {
                    type = "button",
                    name = GetString(FASTRESET_MENU_SECTION_ULTIMATEAUTOMATION_BUTTON_DEFAULTHOUSE_DONATE_TITLE),
                    tooltip = zo_strformat(GetString(FASTRESET_MENU_SECTION_ULTIMATEAUTOMATION_BUTTON_DEFAULTHOUSE_DONATE_TOOLTIP), FastReset.defaultUltiHouse.playerName),
                    func = function()
                        -- show message window
                        SCENE_MANAGER:Show('mailSend')
                        -- wait 200 ms async
                        zo_callLater(
                            function()
                                -- fill out messagebox
                                ZO_MailSendToField:SetText(FastReset.defaultUltiHouse.playerName)
                                ZO_MailSendSubjectField:SetText("Donation for FastResets default Home")
                                QueueMoneyAttachment(1)
                                ZO_MailSendBodyField:TakeFocus()
                            end,
                        200)
                    end,
                    width = "half",
                    disabled = false,
                },
                [7] = {
                    type = "button",
                    name = GetString(FASTRESET_MENU_SECTION_ULTIMATEAUTOMATION_BUTTON_DEFAULTHOUSE_SET_TITLE),
                    tooltip = zo_strformat(GetString(FASTRESET_MENU_SECTION_ULTIMATEAUTOMATION_BUTTON_DEFAULTHOUSE_SET_TOOLTIP),FastReset.defaultUltiHouse.playerName, FastReset.getHouseNameById(FastReset.defaultUltiHouse.id)),
                    func = function()
                        FastReset.savedVariables.ultiHouse = FastReset.defaultUltiHouse
                        FastReset.debug(zo_strformat(GetString(FASTRESET_MENU_SECTION_ULTIMATEAUTOMATION_INFO_HOUSE_SET), FastReset.defaultUltiHouse.playerName, FastReset.getHouseNameById(FastReset.defaultUltiHouse.id)))
                    end,
                    width = "half",
                    --disabled = function() if FastReset.savedVariables.ultiHouse.playerName == FastReset.defaultUltiHouse.playerName then return true else return false end end,
                }
            },
        },
        [6] = {
            type = "submenu",
            name = GetString(FASTRESET_MENU_SECTION_DEATHDETECTION),
            tooltip = GetString(FASTRESET_MENU_SECTION_DEATHDETECTION_TOOLTIP),
            controls = {
                [1] = {
                    type = "description",
                    text = "|cff6600" .. GetString(FASTRESET_MENU_SECTION_DEATHDETECTION_DESCRIPTION) .. "|r",
                    width = "full"
                },
                [2] = {
                    type = "slider",
                    name = GetString(FASTRESET_MENU_SECTION_DEATHDETECTION_SLIDER_DEATHCOUNT_TEXT),
                    getFunc = function() return FastReset.maxDeathCount end,
                    setFunc = function(value) FastReset.maxDeathCount = value end,
                    tooltip = GetString(FASTRESET_MENU_SECTION_DEATHDETECTION_SLIDER_DEATHCOUNT_TOOLTIP),
                    decimals = 0,
                    step = 1,
                    default = 1,
                    min = 1,
                    max = 48,
                }
            }
        },
    }

    LAM2:RegisterAddonPanel("FastResetMenu", panelData)
    LAM2:RegisterOptionControls("FastResetMenu", optionsTable)
end
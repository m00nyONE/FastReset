local strings = {
    FASTRESET_ENABLED = "Enabled",
    FASTRESET_DISABLED = "Disabled",
    FASTRESET_TRIALSTARTED = "Trial started",
    FASTRESET_DEATHDETECTION_STARTED = "death detection started",
    FASTRESET_DEATHDETECTED = "death detected",
    FASTRESET_RESETTING_INSTANCE = "resetting instance",
    FASTRESET_ULTIMATE_FULL = "Ultimate is full",
    FASTRESET_ULTIMATE_FULL_SKIP_RECHARGE = "Ultimate is already full, skipping port to ulti house",

    FASTRESET_ERROR_NOT_LEADER = "only the leader can reset the instance",
    FASTRESET_ERROR_NOT_IN_GROUP = "FastReset disabled because you are not in a group",
    FASTRESET_ERROR_NOT_IN_SAME_ZONE = "Not everyone is in the same Zone ... Maybe you forgot someone?",
    FASTRESET_ERROR_DEATHDETECTION_NOT_STARTED = "DEATH DETECTION NOT STARTED",

    FASTRESET_DIALOG_PORT_TO_LEADER_TITLE = "PORT TO LEADER",
    FASTRESET_DIALOG_PORT_TO_LEADER_TEXT = "Do you want to port back to the leader?",
    FASTRESET_DIALOG_PORT_TO_ULTI_HOUSE_TITLE = "PORT TO ULTI HOUSE",
    FASTRESET_DIALOG_PORT_TO_ULTI_HOUSE_TEXT = "Do you want to port to <<1>>'s house to refill your ulti?",

    FASTRESET_MENU_SECTION_GENERAL = "general",
    FASTRESET_MENU_SECTION_OPTIONS = "options",
    FASTRESET_MENU_CHECKBOX_FASTRESET_TITLE = "FastReset",
    FASTRESET_MENU_CHECKBOX_FASTRESET_TOOLTIP = "enables/disables FastReset",
    FASTRESET_MENU_CHECKBOX_VERBOSEMODE_TITLE = "verbose mode",
    FASTRESET_MENU_CHECKBOX_VERBOSEMODE_TOOLTIP = "enables/disables verbose mode",
    FASTRESET_MENU_CHECKBOX_ULTIHOUSE_TITLE = "port to ulti-house",
    FASTRESET_MENU_CHECKBOX_ULTIHOUSE_TOOLTIP = "enables/disables automatic teleportation to ulti house",
    FASTRESET_MENU_DESCRIPTION_ULTIHOUSE_NOT_SET = "ulti-house not set",
    FASTRESET_MENU_SLIDER_DEATHS_TITLE = "Deaths until reset",
    FASTRESET_MENU_SLIDER_DEATHS_TOOLTIP = "sets the amount of deaths until an autoreset is performed",
    FASTRESET_MENU_BUTTON_SETHOUSE_TITLE = "set house",
    FASTRESET_MENU_BUTTON_SETHOUSE_TOOLTIP = "set the house you are currently in to your ulti-recharge house",
    FASTRESET_MENU_INFO_HOUSE_SET = "House set to <<1>>'s <<2>>",
    FASTRESET_MENU_ERROR_NOT_IN_HOUSE = "You are not inside of a house",
}

for stringId, stringValue in pairs(strings) do
	ZO_CreateStringId(stringId, stringValue)
	SafeAddVersion(stringId, 1)
end
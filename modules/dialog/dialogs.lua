local function callbackYes() end
local function callbackNo() end


libDialog:RegisterDialog(
    FastReset.name, 
    "PortToUltiHouse",
    GetString(FASTRESET_DIALOG_PORT_TO_ULTI_HOUSE_TITLE),
    zo_strformat(GetString(FASTRESET_DIALOG_PORT_TO_ULTI_HOUSE_TEXT), FastReset.savedVariables.ultiHouse.playerName),
    callbackYes, callbackNo, nil, false, nil, nil)
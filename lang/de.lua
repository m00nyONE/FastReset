local strings = {
    FASTRESET_ENABLED = "Aktiviert",
    FASTRESET_DISABLED = "Deaktiviert",
    FASTRESET_TRIALSTARTED = "Raid hat begonnen",
    FASTRESET_DEATHDETECTION_STARTED = "Todeserkennung gestartet",
    FASTRESET_DEATHDETECTED = "Tod erkannt",
    FASTRESET_RESETTING_INSTANCE = "setze Instanz zurück",
    FASTRESET_ULTIMATE_FULL = "Ulti ist voll",
    FASTRESET_ULTIMATE_FULL_SKIP_RECHARGE = "Ulti ist bereits voll, der Port in das Ulti-Haus wird übersprungen",

    FASTRESET_ERROR_NOT_LEADER = "Nur der Gruppenleiter kann die Instanz zurücksetzen",
    FASTRESET_ERROR_NOT_IN_GROUP = "FastReset deaktiviert, da du nicht Mitglied einer Gruppe bist",
    FASTRESET_ERROR_NOT_IN_SAME_ZONE = "Es sind nicht alle in der gleichen Zone ... Habt ihr jemanden vergessen?",
    FASTRESET_ERROR_DEATHDETECTION_NOT_STARTED = "TODESERKENNUNG NICHT GETARTET",

    FASTRESET_DIALOG_PORT_TO_LEADER_TITLE = "TELEPORT ZUM GRUPPENLEITER",
    FASTRESET_DIALOG_PORT_TO_LEADER_TEXT = "Möchtest du dich zum Gruppenleiter teleportieren?",
    FASTRESET_DIALOG_PORT_TO_ULTI_HOUSE_TITLE = "TELEPORT INS ULTI-HAUS",
    FASTRESET_DIALOG_PORT_TO_ULTI_HOUSE_TEXT = "Möchtest du dich in <<1>>'s Haus teleportieren um deine Ulti aufzuladen?",

    FASTRESET_MENU_SECTION_GENERAL = "Allgemein",
    FASTRESET_MENU_SECTION_OPTIONS = "Optionen",
    FASTRESET_MENU_CHECKBOX_FASTRESET_TITLE = "FastReset",
    FASTRESET_MENU_CHECKBOX_FASTRESET_TOOLTIP = "aktiviert/deaktiviert FastReset",
    FASTRESET_MENU_CHECKBOX_VERBOSEMODE_TITLE = "Info Modus",
    FASTRESET_MENU_CHECKBOX_VERBOSEMODE_TOOLTIP = "aktiviert/deaktiviert den Info Modus",
    FASTRESET_MENU_CHECKBOX_ULTIHOUSE_TITLE = "Port ins Ulti-Haus",
    FASTRESET_MENU_CHECKBOX_ULTIHOUSE_TOOLTIP = "aktiviert/deaktiviert die automatische Teleportation ins Ulti-Haus nach dem verlassen der Instanz wenn deine Ulti nicht voll ist",
    FASTRESET_MENU_DESCRIPTION_ULTIHOUSE_NOT_SET = "Ulti-House nicht festgelegt",
    FASTRESET_MENU_SLIDER_DEATHS_TITLE = "Todeslimit",
    FASTRESET_MENU_SLIDER_DEATHS_TOOLTIP = "gibt an wie viele Gruppenmitglieder sterben dürfen bevor die Instanz zurückgesetzt wird",
    FASTRESET_MENU_BUTTON_SETHOUSE_TITLE = "Ulti-Haus festlegen",
    FASTRESET_MENU_BUTTON_SETHOUSE_TOOLTIP = "Legt das haus indem du dich gerade befindest las Ulti-Haus fest",
    FASTRESET_MENU_INFO_HOUSE_SET = "Ulti-Haus <<2>> von <<1>> gesetzt ",
    FASTRESET_MENU_ERROR_NOT_IN_HOUSE = "Du bist nicht in einem Haus",
}

for stringId, stringValue in pairs(strings) do
	ZO_CreateStringId(stringId, stringValue)
	SafeAddVersion(stringId, 1)
end

-- the official way does not work somehow o.O
--[[ for stringId, stringValue in pairs(strings) do
	SafeAddString(stringId, stringValue, 1)
end ]]
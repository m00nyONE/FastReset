local strings = {
    FASTRESET_ENABLED = "Aktiviert",
    FASTRESET_DISABLED = "Deaktiviert",
    FASTRESET_TRIALSTARTED = "Raid hat begonnen",
    FASTRESET_DEATHDETECTION_STARTED = "Todeserkennung gestartet",
    FASTRESET_DEATHDETECTED = "ist gestorben",
    FASTRESET_RESETTING_INSTANCE = "setze Instanz zurück",
    FASTRESET_ULTIMATE_FULL = "Ulti ist voll",
    FASTRESET_ULTIMATE_FULL_SKIP_RECHARGE = "Ulti ist bereits voll, der Port in das Ulti-Haus wird übersprungen",
    FASTRESTE_PORTBACK_ENABLED = "portBack tracking aktiviert",
    FASTRESTE_PORTBACK_DISABLED = "portBack tracking deaktiviert",

    FASTRESET_ERROR_NOT_LEADER = "Nur der Gruppenleiter kann die Instanz zurücksetzen",
    FASTRESET_ERROR_NOT_IN_GROUP = "FastReset deaktiviert, da du nicht Mitglied einer Gruppe bist",
    FASTRESET_ERROR_NOT_IN_SAME_ZONE = "Es sind nicht alle in der gleichen Zone ... Habt ihr jemanden vergessen?",
    FASTRESET_ERROR_DEATHDETECTION_NOT_STARTED = "TODESERKENNUNG NICHT GETARTET",
    FASTRESET_ERROR_NOTININSTANCE = "Du befindest dich in keiner Instanz",
    FASTRESET_ERROR_NOHOUSEDEFINED = "Du musst erst ein Ulti-Haus in den Addon-Einstellungen festlegen",
    FASTRESET_ERROR_ZONEISNOTHOME = "Du befindest dich nicht in einem Haus",
    FASTRESET_ERROR_NO_TRIAL_SET = "Es wurde nichts gesetzt zu dem du automatisch zurückporten kannst",

    FASTRESET_DIALOG_PORT_TO_LEADER_TITLE = "TELEPORT ZUM GRUPPENLEITER",
    FASTRESET_DIALOG_PORT_TO_LEADER_TEXT = "Möchtest du dich zum Gruppenleiter teleportieren?",
    FASTRESET_DIALOG_PORT_TO_ULTI_HOUSE_TITLE = "TELEPORT INS ULTI-HAUS",
    FASTRESET_DIALOG_PORT_TO_ULTI_HOUSE_TEXT = "Möchtest du dich in <<1>>'s Haus teleportieren um deine Ulti aufzuladen?",
    FASTRESET_DIALOG_EXIT_INSTANCE_TITLE = "INSTANZ VERLASSEN",
    FASTRESET_DIALOG_EXIT_INSTANCE_TEXT = "Möchtest du die Instanz verlassen?",

    FASTRESET_MENU_DESCRIPTION = "Bei Aktivierung von FastReset wirst du, nach dem Ableben eines Gruppenmitglieds, aus der Prüfung teleportiert und in ein von dir vorher ausgewähltes Haus gebracht, um deine Ulti aufzuladen. Nach dem Aufladen der Ulimativen Fähigkeit wirst du dann wieder in die Instanz zurückteleportiert, sobald dein Leader diese betreten hat.",
    FASTRESET_MENU_SECTION_GENERAL = "Allgemein",
    FASTRESET_MENU_SECTION_GENERAL_CHECKBOX_ENABLE_TITLE = "Aktiviert",
    FASTRESET_MENU_SECTION_GENERAL_CHECKBOX_ENABLE_TOOLTIP = "aktiviert/deaktiviert FastReset",
    FASTRESET_MENU_SECTION_GENERAL_CHECKBOX_VERBOSEMODE_TITLE = "Info Modus",
    FASTRESET_MENU_SECTION_GENERAL_CHECKBOX_VERBOSEMODE_TOOLTIP = "aktiviert/deaktiviert den Info Modus",
    FASTRESET_MENU_SECTION_GENERAL_CHECKBOX_SPEEDYMODE_TITLE = "Sofort Modus",
    FASTRESET_MENU_SECTION_GENERAL_CHECKBOX_SPEEDYMODE_TOOLTIP = "aktiviert/deaktiviert den sofort modus. Es wird nicht auf den Gruppenleiter gewartet um zurück in die Instanz zu teleportieren. Stattdessen wirst du sofort teleportiert.",
    FASTRESET_MENU_SECTION_GENERAL_CHECKBOX_SPEEDYMODE_WARNING = "Wenn der Gruppenleiter lange Ladezeiten hat, kann es passieren, dass du dich bereits zurück teleportierst obwohl die Instanz noch nicht vollständig zurückgesetzt wurde. Dies kann zu Zeitverlust führen. Es kostet außerdem Gold.",
    FASTRESET_MENU_SECTION_GENERAL_CHECKBOX_EXPERIMENTAL_TITLE = "experimentelle Optionen",
    FASTRESET_MENU_SECTION_GENERAL_CHECKBOX_EXPERIMENTAL_TOOLTIP = "aktiviert/deaktiviert experimentelle Optionen",

    FASTRESET_MENU_SECTION_ULTIMATEAUTOMATION = "Ulti-Automatisierung",
    FASTRESET_MENU_SECTION_ULTIMATEAUTOMATION_TOOLTIP = "Einstellung für die Ulti-Automatisierung nach dem Reset",
    FASTRESET_MENU_SECTION_ULTIMATEAUTOMATION_CHECKBOX_PORTTOULTIHOUSE_TITLE = "Port ins Ulti-Haus",
    FASTRESET_MENU_SECTION_ULTIMATEAUTOMATION_CHECKBOX_PORTTOULTIHOUSE_TOOLTIP = "Aktiviert/Deaktiviert die automatische Teleportation ins Ulti-Haus nach dem Verlassen der Instanz, wenn deine Ulti nicht voll ist.",
    FASTRESET_MENU_SECTION_ULTIMATEAUTOMATION_CHECKBOX_PORTTOULTIHOUSEWHENNOT500_TITLE = "Komplett auffüllen",
    FASTRESET_MENU_SECTION_ULTIMATEAUTOMATION_CHECKBOX_PORTTOULTIHOUSEWHENNOT500_TOOLTIP = "Aktiviert/Deaktiviert die automatische Teleportation ins Ulti-Haus nach dem Verlassen der Instanz, wenn deine Ulti nicht maximal voll ist. Praktisch, wenn du Sets wie Saxhleel oder Meisterarchitekt trägst.",
    FASTRESET_MENU_SECTION_ULTIMATEAUTOMATION_DESCRIPTION_ULTIHOUSE_NOT_SET = "Ulti-House nicht festgelegt.",
    FASTRESET_MENU_SECTION_ULTIMATEAUTOMATION_BUTTON_SETHOUSE_TITLE = "Ulti-Haus festlegen",
    FASTRESET_MENU_SECTION_ULTIMATEAUTOMATION_BUTTON_SETHOUSE_TOOLTIP = "Legt das Haus, in dem du dich gerade befindest als Ulti-Haus fest.",
    FASTRESET_MENU_SECTION_ULTIMATEAUTOMATION_BUTTON_DEFAULTHOUSE_DONATE_TITLE = "Spenden",
    FASTRESET_MENU_SECTION_ULTIMATEAUTOMATION_BUTTON_DEFAULTHOUSE_DONATE_TOOLTIP = "Spende an <<1>> für das Standard Ulti-Haus.",
    FASTRESET_MENU_SECTION_ULTIMATEAUTOMATION_BUTTON_DEFAULTHOUSE_SET_TITLE = "Ulti-Haus zurücksetzen",
    FASTRESET_MENU_SECTION_ULTIMATEAUTOMATION_BUTTON_DEFAULTHOUSE_SET_TOOLTIP = "Setzt das Ulti-Haus auf <<1>>'s <<2>> zurück.",
    FASTRESET_MENU_SECTION_ULTIMATEAUTOMATION_INFO_HOUSE_SET = "<<2>> von <<1>> als Ulti-Haus gesetzt.",
    FASTRESET_MENU_SECTION_ULTIMATEAUTOMATION_ERROR_NOT_IN_HOUSE = "Du bist nicht in einem Haus.",

    FASTRESET_MENU_SECTION_DEATHDETECTION = "Todeserkennung",
    FASTRESET_MENU_SECTION_DEATHDETECTION_TOOLTIP = "Einstellungen für die automatische Todeserkennung",
    FASTRESET_MENU_SECTION_DEATHDETECTION_DESCRIPTION = "ACHTUNG! - Diese Einstellung wird vom Leader getätigt!",
    FASTRESET_MENU_SECTION_DEATHDETECTION_SLIDER_DEATHCOUNT_TEXT = "Todesanzahl",
    FASTRESET_MENU_SECTION_DEATHDETECTION_SLIDER_DEATHCOUNT_TOOLTIP = "Setzt die Anzahl der Tode die spieler sterben dürfen bevor FastReset seine Automaisierung ausführt",
    FASTRESET_MENU_SECTION_DEATHDETECTION_CHECKBOX_CONFIRMEXIT_TEXT = "Verlassen bestätigen",
    FASTRESET_MENU_SECTION_DEATHDETECTION_CHECKBOX_CONFIRMEXIT_TOOLTIP = "Zeigt dir vor dem Kick durch den RaidLead einen Bestätigungsdialog an",
    FASTRESET_MENU_SECTION_DEATHDETECTION_CHECKBOX_HODOREJECT_TEXT = "zusätzlicher Hodor-Eject",
    FASTRESET_MENU_SECTION_DEATHDETECTION_CHECKBOX_HODOREJECT_TOOLTIP = "sende zusätzlich zum FastReset-Eject noch Hodor-Eject um Teilnehmer aus der Instanz zu werfen, die FastReset nicht installiert haben",
    FASTRESET_MENU_SECTION_DEATHDETECTION_CHECKBOX_HODOREJECT_WARNING = "EXPERIMENTELL: zu viele Pings auf einmal können zu einem kick führen",

    FASTRESET_SLASHCOMMAND_DESCRIPTION = "startet FastReset manuell",
    FASTRESET_SLASHCOMMAND_ENABLE_DESCRIPTION = "aktiviert FastReset",
    FASTRESET_SLASHCOMMAND_DISABLE_DESCRIPTION = "deaktiviert FastReset",
    FASTRESET_SLASHCOMMAND_ULTI_DESCRIPTION = "teleportiert dich in dein Ulti-Haus",
    FASTRESET_SLASHCOMMAND_LEADER_DESCRIPTION = "teleportiert dich zum Gruppenleiter",
    FASTRESET_SLASHCOMMAND_LEAVE_DESCRIPTION = "schnelles Verlassen der Instanz",
    FASTRESET_SLASHCOMMAND_RESET_DESCRIPTION = "setzt die Instanz zurück",
    FastReset_SLASHCOMMAND_PORTBACK_DESCRIPTION = "teleportiere zur letzten instanz zurück",
    FASTRESET_SLASHCOMMAND_SET_DESCRIPTION = "Setzt werte für FastReset",
    FASTRESET_SLASHCOMMAND_SET_ERROR_NOVALUE = "ERROR: Kein Wert spezifiziert",
    FASTRESET_SLASHCOMMAND_SET_DEATHS_DESCRIPTION = "<anzahl> - legt die Anzahl der Tode vor dem resetten der Instanz fest",
    FASTRESET_SLASHCOMMAND_SET_DEATHS_ERROR_MISSING_ARGUMENT = "fehlendes Argument <anzahl>",
    FASTRESET_SLASHCOMMAND_SET_DEATHS_ERROR_OUTOFRANGE = "Es sind nur Zahlen zwischen 1 und 48 erlaubt",
    FASTRESET_SLASHCOMMAND_SET_DEATHS_MSG_SUCCESS = "setze Anzahl der maximalen Tode auf <<1>>",

    SI_BINDING_NAME_FASTRESET_HOTKEY_TOGGLE = "aktiviere/deaktiviere FastReset",
    SI_BINDING_NAME_FASTRESET_HOTKEY_AUTOMATION = "starte Automatisierung manuell",
    SI_BINDING_NAME_FASTRESET_HOTKEY_RESET = "Instanz resetten",
    SI_BINDING_NAME_FASTRESET_HOTKEY_ULTIHOME = "Porte ins Ulti-Haus",
    SI_BINDING_NAME_FASTRESET_HOTKEY_PORTTOLEADER = "Porte zum Leader",
    SI_BINDING_NAME_FASTRESET_HOTKEY_LEAVE = "verlasse Instanz (nur du)",
}

for stringId, stringValue in pairs(strings) do
	ZO_CreateStringId(stringId, stringValue)
	SafeAddVersion(stringId, 1)
end

-- the official way does not work somehow o.O
--[[ for stringId, stringValue in pairs(strings) do
	SafeAddString(stringId, stringValue, 1)
end ]]
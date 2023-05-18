FastReset = FastReset or {}
FastReset.name = "FastReset"
FastReset.color = "8B0000"
FastReset.credits = "@m00nyONE"
FastReset.version = "2.5.1"
FastReset.variableVersion = 1
FastReset.defaultVariables = {
    enabled = false,
    -- enableInDungeons = true,
    verboseModeEnabled = true,
    speedyMode = false,
    autoResetDelay = 250,
    autoPortToUltiHouseDelay = 1000,
    autoPortToUltiHouseEnabled = false,
    autoPortToUltiHouseWithMaxUltimate = false,
    saveLastPosition = true,
    confirmExit = false,
    sendAdditionalHodorEject = false,
    maxDeathCount = 1,
    ultiHouse = {
        playerName = "",
        id = 0
    },
    enableExperimentalFeatures = false,
}
FastReset.defaultUltiHouse = {
    playerName = "@No4Sniper2k3",
    id = 46
}
FastReset.ZoneID = -1
FastReset.global = FastReset.global or {}
FastReset.global.shareInterval = 3000
FastReset.global.ZoneInfo = {
    -- Trials
    [636] = {nodeIndex = 230, longName = "Hel Ra Citadel", shortName = "HRC", type = "trial"},
    [638] = {nodeIndex = 231, longName = "Aetherian Archive", shortName = "AA", type = "trial"},
    [639] = {nodeIndex = 232, longName = "Sanctum Ophidia", shortName = "SO", type = "trial"},
    [725] = {nodeIndex = 258, longName = "Maw of Lorkhaj", shortName = "MoL", type = "trial"},
    [975] = {nodeIndex = 331, longName = "Halls of Fabrication", shortName = "HoF", type = "trial"},
    [1000] = {nodeIndex = 346, longName = "Asylum Sanctorium", shortName = "AS", type = "trial"},
    [1051] = {nodeIndex = 364, longName = "Cloudrest", shortName = "CR", type = "trial"},
    [1121] = {nodeIndex = 399, longName = "Sunspire", shortName = "SS", type = "trial"},
    [1196] = {nodeIndex = 434, longName = "Kyne's Aegis", shortName = "KA", type = "trial"},
    [1263] = {nodeIndex = 468, longName = "Rockgrove", shortName = "RG", type = "trial"},
    [1344] = {nodeIndex = 488, longName = "Dreadsail Reef", shortName = "DSR", type = "trial"},
    -- Solo Arenas (fast Reset will only work in a group! also, you can not instant reset solo arenas )
    -- [377] = {nodeIndex = 250, longName = "Maelstrom Arena", shortName = "MSA", type = "arena"},
    -- [1227] = {nodeIndex = 457, longName = "Vateshran Arena", shortName = "VSA", type = "arena"},
    -- 4-Man Arenas
    [635] = {nodeIndex = 270, longName = "Dragonstar Arena", shortName = "DSA", type = "arena"},
    [1082] = {nodeIndex = 378, longName = "Blackrose Prison", shortName = "BRP", type = "arena"},
    -- Base Game Dungeons
    [283] = {nodeIndex = 98, longName = "Fungal Grotto I", shortName = "FG1", type = "dungeon"},
    [934] = {nodeIndex = 266, longName = "Fungal Grotto II", shortName = "FG2", type = "dungeon"},
    [380] = {nodeIndex = 194, longName = "Banished Cells I", shortName = "BC1", type = "dungeon"},
    [935] = {nodeIndex = 262, longName = "Banished Cells II", shortName = "BC2", type = "dungeon"},
    [126] = {nodeIndex = 191, longName = "Elden Hollow I", shortName = "EH1", type = "dungeon"},
    [931] = {nodeIndex = 265, longName = "Elden Hollow II", shortName = "EH2", type = "dungeon"},
    [176] = {nodeIndex = 197, longName = "City of Ash I", shortName = "CoA1", type = "dungeon"},
    [681] = {nodeIndex = 268, longName = "City of Ash II", shortName = "CoA2", type = "dungeon"},
    [130] = {nodeIndex = 190, longName = "Crypt of Hearts I", shortName = "CoH1", type = "dungeon"},
    [932] = {nodeIndex = 269, longName = "Crypt of Hearts II", shortName = "CoH2", type = "dungeon"},
    [63] = {nodeIndex = 198, longName = "Darkshade Caverns I", shortName = "DSC1", type = "dungeon"},
    [930] = {nodeIndex = 264, longName = "Darkshade Caverns II", shortName = "DSC2", type = "dungeon"},
    [144] = {nodeIndex = 193, longName = "Spindleclutch I", shortName = "SC1", type = "dungeon"},
    [936] = {nodeIndex = 267, longName = "Spindleclutch II", shortName = "SC2", type = "dungeon"},
    [146] = {nodeIndex = 189, longName = "Wayrest Sewers I", shortName = "WRS1", type = "dungeon"},
    [933] = {nodeIndex = 263, longName = "Wayrest Sewers II", shortName = "WRS2", type = "dungeon"},
    [148] = {nodeIndex = 192, longName = "Arx Corinium", shortName = "AC", type = "dungeon"},
    [38] = {nodeIndex = 186, longName = "Blackheart Haven", shortName = "BH", type = "dungeon"},
    [64] = {nodeIndex = 187, longName = "Blessed Crucible", shortName = "BC", type = "dungeon"},
    [449] = {nodeIndex = 195, longName = "Direfrost Keep", shortName = "DK", type = "dungeon"},
    [31] = {nodeIndex = 185, longName = "Selene's Web", shortName = "SW", type = "dungeon"},
    [131] = {nodeIndex = 188, longName = "Tempest Island", shortName = "TI", type = "dungeon"},
    [11] = {nodeIndex = 184, longName = "Vaults of Madness", shortName = "VoM", type = "dungeon"},
    [22] = {nodeIndex = 196, longName = "Volenfell", shortName = "VF", type = "dungeon"},
    -- DLC Dungeons
    [688] = {nodeIndex = 247, longName = "White Gold Tower", shortName = "WGT", type = "dungeon"},
    [678] = {nodeIndex = 236, longName = "Imperial City Prison", shortName = "ICP", type = "dungeon"},
    [843] = {nodeIndex = 260, longName = "Ruins of Mazzatun",  shortName = "ROM", type = "dungeon"},
    [848] = {nodeIndex = 261, longName = "Cradle of Shadows", shortName = "COS", type = "dungeon"},
    [974] = {nodeIndex = 332, longName = "Falkreath Hold", shortName = "FH", type = "dungeon"},
    [973] = {nodeIndex = 326, longName = "Bloodroot Forge", shortName = "BF", type = "dungeon"},
    [1009] = {nodeIndex = 341, longName = "Fang Lair", shortName = "FL", type = "dungeon"},
    [1010] = {nodeIndex = 363, longName = "Scalecaller Peak", shortName = "SP", type = "dungeon"},
    [1052] = {nodeIndex = 371, longName = "Moon Hunter Keep", shortName = "MHK", type = "dungeon"},
    [1055] = {nodeIndex = 370, longName = "March of Sacrifices", shortName = "MOS", type = "dungeon"},
    [1080] = {nodeIndex = 389, longName = "Frostvault", shortName = "FV", type = "dungeon"},
    [1081] = {nodeIndex = 390, longName = "Depths of Malatar", shortName = "DOM", type = "dungeon"},
    [1123] = {nodeIndex = 398, longName = "Lair of Maarselok", shortName = "LOM", type = "dungeon"},
    [1122] = {nodeIndex = 391, longName = "Moongrave Fane", shortName = "MF", type = "dungeon"},
    [1152] = {nodeIndex = 424, longName = "Icereach", shortName = "IR", type = "dungeon"},
    [1153] = {nodeIndex = 425, longName = "Unhallowed Grave", shortName = "UG", type = "dungeon"},
    [1197] = {nodeIndex = 435, longName = "Stone Garden", shortName = "SG", type = "dungeon"},
    [1201] = {nodeIndex = 436, longName = "Castle Thorn", shortName = "CT", type = "dungeon"},
    [1228] = {nodeIndex = 437, longName = "Black Drake Villa", shortName = "BDV", type = "dungeon"},
    [1229] = {nodeIndex = 454, longName = "The Cauldron", shortName = "TC", type = "dungeon"},
    [1267] = {nodeIndex = 470, longName = "Red Petal Bastion", shortName = "RPB", type = "dungeon"},
    [1268] = {nodeIndex = 469, longName = "Dread Cellar", shortName = "DC", type = "dungeon"},
    [1301] = {nodeIndex = 497, longName = "Coral Aerie", shortName = "CA", type = "dungeon"},
    [1302] = {nodeIndex = 498, longName = "Shipwright's Regret", shortName = "SR", type = "dungeon"},
    [1360] = {nodeIndex = 520, longName = "Earthen Root Enclave", shortName = "ERE", type = "dungeon"},
    [1361] = {nodeIndex = 521, longName = "Graven Deep", shortName = "GD", type = "dungeon"}
}
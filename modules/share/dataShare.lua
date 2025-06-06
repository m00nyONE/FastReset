FastReset = FastReset or {}
FastReset.Share = FastReset.Share or {}

local LGB = LibGroupBroadcast
local _LGBHandler = {}
local _LGBProtocols = {}
local MESSAGE_ID_FASTRESET = 35

FastReset.Share = {
    MAXDEATHCOUNT = {
        OFFSET = 0,
        SIZE = 6,
        VALUE = 1
    },
    DEATHCOUNT = {
        OFFSET = 7,
        SIZE = 6,
        VALUE = 0
    },
    EXITINSTANCE = {
        OFFSET = 13,
        SIZE = 1,
        VALUE = 0
    },
    INNEWTRIAL = {
        OFFSET = 14,
        SIZE = 1,
        VALUE = 0
    },

    DeathCountDelay = 10000,
}


function FastReset.Share:TransmitData(now)
    local data = {}
    data.maxDeathCount = FastReset.Share.MAXDEATHCOUNT.VALUE
    data.deathCount = FastReset.Share.DEATHCOUNT.VALUE
    data.exitInstance = FastReset.Share.EXITINSTANCE.VALUE
    data.inNewTrial = FastReset.Share.INNEWTRIAL.VALUE

    _LGBProtocols[MESSAGE_ID_FASTRESET]:Send(data)
end


local function messageHandler(unitTag, data)
    if not FastReset.savedVariables.enabled then return end
    if not IsUnitGroupLeader(unitTag) then return end

    FastReset.Share.MAXDEATHCOUNT.VALUE = data.maxDeathCount
    FastReset.Share.DEATHCOUNT.VALUE = data.deathCount
    FastReset.Share.INNEWTRIAL.VALUE = data.inNewTrial

    if data.exitInstance == 1 then
        FastReset.Member.KickRecieved()
        --d("recieved exit command")
    end
    if data.inNewTrial == 1 then
        --d("recieved that the leader is in the new trial and we can port to him")
    end
end

local function declareLGBProtocols()
    local CreateNumericField = LGB.CreateNumericField
    local CreateFlagField = LGB.CreateFlagField

    local protocolOptions = {
        isRelevantInCombat = true
    }

    local handler = LGB:RegisterHandler("FastReset")
    handler:SetDisplayName("FastReset")
    handler:SetDescription("Allows automatically resetting a trial instance when deaths occur")

    local protocolFastReset = handler:DeclareProtocol(MESSAGE_ID_FASTRESET, "FastReset")
    protocolFastReset:AddField(CreateNumericField("maxDeathCount", {
        minValue = 0,
        maxValue = 127,
    }))
    protocolFastReset:AddField(CreateNumericField("deathCount", {
        minValue = 0,
        maxValue = 127,
    }))
    protocolFastReset:AddField(CreateFlagField("exitInstance", {
        defaultValue = false,
    }))
    protocolFastReset:AddField(CreateFlagField("inNewTrial", {
        defaultValue = false,
    }))
    protocolFastReset:OnData(messageHandler)
    protocolFastReset:Finalize(protocolOptions)

    _LGBHandler = handler
    _LGBProtocols[MESSAGE_ID_FASTRESET] = protocolFastReset
end

function FastReset.Share:Register()
    declareLGBProtocols()
end
function FastReset.Share:Unregister()
    d("")
end
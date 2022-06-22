FastReset = FastReset or {}
FastReset.Share = FastReset.Share or {}

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

    MapID = 21, -- Khenarthi's Roost (max data: 40000^2-1)
    DeathCountDelay = 10000,
}


local function rshift(data, by)
    --FastReset.debug("shift right: " .. data .. " by " .. 2^by .. " - got: " .. zo_floor(data / (2^by)))
    return zo_floor(data / (2^by))
end
local function lshift(data, by)
    --FastReset.debug("shift left: " .. data .. " by " .. 2^by .. " - got: " .. (data* (2^by)))
    return (data* (2^by))
end

local function decode(data, offset, size)
    data = rshift(data, offset)
    return data % (2^size)
end
local function encode(data, offset, size)
    if size ~= nil then
        data = data % (2^size)
    end
    return lshift(data, offset)
end

local function encodeData(data)
    if type(data) ~= "table" then return nil end

    local result = 0
    result = result + encode(data.MAXDEATHCOUNT, FastReset.Share.MAXDEATHCOUNT.OFFSET, FastReset.Share.MAXDEATHCOUNT.SIZE)
    result = result + encode(data.DEATHCOUNT, FastReset.Share.DEATHCOUNT.OFFSET, FastReset.Share.DEATHCOUNT.SIZE)
    result = result + encode(data.EXITINSTANCE, FastReset.Share.EXITINSTANCE.OFFSET, FastReset.Share.EXITINSTANCE.SIZE)
    result = result + encode(data.INNEWTRIAL, FastReset.Share.INNEWTRIAL.OFFSET, FastReset.Share.INNEWTRIAL.SIZE)

    return result
end
local function decodeData(data)
    local result = {}
    result.MAXDEATHCOUNT = decode(data, FastReset.Share.MAXDEATHCOUNT.OFFSET, FastReset.Share.MAXDEATHCOUNT.SIZE)
    result.DEATHCOUNT = decode(data, FastReset.Share.DEATHCOUNT.OFFSET, FastReset.Share.DEATHCOUNT.SIZE)
    result.EXITINSTANCE = decode(data, FastReset.Share.EXITINSTANCE.OFFSET, FastReset.Share.EXITINSTANCE.SIZE)
    result.INNEWTRIAL = decode(data, FastReset.Share.INNEWTRIAL.OFFSET, FastReset.Share.INNEWTRIAL.SIZE)
    return result
end

function FastReset.Share.dataShareHandler(tag, rawData)
    if not IsUnitGroupLeader(tag) then return end

    local data = decodeData(rawData)

    FastReset.Share.MAXDEATHCOUNT.VALUE = data.MAXDEATHCOUNT
    FastReset.Share.DEATHCOUNT.VALUE = data.DEATHCOUNT
    FastReset.Share.INNEWTRIAL.VALUE = data.INNEWTRIAL

    --[[
    FastReset.debug("MAXDEATHCOUNT: " .. tostring(data.MAXDEATHCOUNT))
    FastReset.debug("DEATHCOUNT: " .. tostring(data.DEATHCOUNT))
    FastReset.debug("EXITINSTANCE: " .. tostring(data.EXITINSTANCE))
    FastReset.debug("INNEWTRIAL: " .. tostring(data.INNEWTRIAL))
    ]]--

    if data.EXITINSTANCE == 1 then
        FastReset.Member.KickRecieved()
        --d("recieved exit command")
    end
    --[[
    if data.INNEWTRIAL == 1 then
        --d("recieved that the leader is in the new trial and we can port to him")
    end
    ]]--
end



--function FastReset.share.PrepareData()
--
--end

local function packData()
    local rawData = {}
    rawData.MAXDEATHCOUNT = FastReset.Share.MAXDEATHCOUNT.VALUE
    rawData.DEATHCOUNT = FastReset.Share.DEATHCOUNT.VALUE
    rawData.EXITINSTANCE = FastReset.Share.EXITINSTANCE.VALUE
    rawData.INNEWTRIAL = FastReset.Share.INNEWTRIAL.VALUE
    return encodeData(rawData)
end

function FastReset.Share:TransmitData(now)
    local data = packData()
    if not now then
        self.dataShare:QueueData(data)
    else
        self.dataShare:SendData(data)
    end

    --[[
    local sentData = decodeData(data)
    FastReset.debug("sent data: ")
    FastReset.debug("MAXDEATHCOUNT: " .. sentData.MAXDEATHCOUNT)
    FastReset.debug("DEATHCOUNT: " .. sentData.DEATHCOUNT)
    FastReset.debug("EXITINSTANCE: " .. sentData.EXITINSTANCE)
    FastReset.debug("INNEWTRIAL: " .. sentData.INNEWTRIAL)
    ]]--
end

--[[
local function sendTestData()
    local rawData = {}
    rawData.MAXDEATHCOUNT = math.random( 1, 63)
    rawData.DEATHCOUNT = math.random(1, 63)
    rawData.EXITINSTANCE = math.random(0, 1)
    rawData.INNEWTRIAL = math.random(0, 1)

    FastReset.debug("sent MAXDEATHCOUNT: " .. tostring(rawData.MAXDEATHCOUNT))
    FastReset.debug("sent DEATHCOUNT: " .. tostring(rawData.DEATHCOUNT))
    FastReset.debug("sent EXITINSTANCE: " .. tostring(rawData.EXITINSTANCE))
    FastReset.debug("sent INNEWTRIAL: " .. tostring(rawData.INNEWTRIAL))

    local encoded = encodeData(rawData)
    FastReset.debug("encoded data: " .. tostring(encoded))

    FastReset.Share.dataShare:SendData(encoded)
end
SLASH_COMMANDS["/frtest"] = function(str)
    sendTestData()
end

SLASH_COMMANDS["/frtest"] = function(str)
    FastReset.Share:TransmitData(true)
end
]]--

function FastReset.Share:Register()
    self.dataShare = LibDataShare:RegisterMap(FastReset.name, self.MapID, self.dataShareHandler)
end
function FastReset.Share:Unregister()
    LibDataShare:UnregisterMap(FastReset.Share.MapID)
    self.dataShare = nil
end
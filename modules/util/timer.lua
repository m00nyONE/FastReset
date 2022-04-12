FastReset = FastReset or {}
FastReset.util = FastReset.util or {}
FastReset.util.Timer = ZO_Object:Subclass()

FastReset.addonLoadTime = 0

function FastReset.util.Timer:New()
    local obj = ZO_Object.New(self)
    obj:Initialize()
    return obj
end
function FastReset.util.Timer:Initialize()
    self.startTime = 0
    self.endTime = 0
    self.elapsedTime = 0
    self.paused = false
end
function FastReset.util.Timer:Start()
    self.startTime = GetGameTimeMilliseconds()
end

function FastReset.util.Timer:Stop()
    self.endTime = GetGameTimeMilliseconds()
    self.elapsedTime = self.endTime - self.startTime
end

function FastReset.util.Timer:AddToLoadTime()
    FastReset.addonLoadTime = FastReset.addonLoadTime + self.elapsedTime
end

function FastReset.util.Timer:GetElapsedTime()
    return self.elapsedTime
end

function FastReset.util.Timer:Pause()
    self.elapsedTime = self.elapsedTime + (GetGameTimeMilliseconds() - self.startTime)
    self.startTime = 0
    self.endTime = 0
    self.paused = true
end
function FastReset.util.Timer:Resume()
    if not self.paused then return end
    self.startTime = GetGameTimeMilliseconds()
end
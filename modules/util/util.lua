FastReset = FastReset or {}
FastReset.util = FastReset.util or {}

function FastReset.debug(str)
    if FastReset.savedVariables.verboseModeEnabled then
        d("|c" .. FastReset.color .. "FastReset: " .. str .. "|r")
    end
end

function FastReset.util.filterName(unfiltered)
    local i, j = string.find(unfiltered, "%^")
    if i == nil then
        return unfiltered
    end
    return string.sub(unfiltered, 1, i-1)
end

function FastReset.util.getHouseNameById(id)
    if id == 0 then return GetString(FASTRESET_ERROR_ZONEISNOTHOME) end
    local h = GetCollectibleName(GetCollectibleIdForHouse(id))
    return FastReset.util.filterName(h)
end

function FastReset.util.getUltimateCost()
    local ult1 = GetSlotBoundId(ACTION_BAR_ULTIMATE_SLOT_INDEX + 1, HOTBAR_CATEGORY_BACKUP)
    local ult2 = GetSlotBoundId(ACTION_BAR_ULTIMATE_SLOT_INDEX + 1, HOTBAR_CATEGORY_PRIMARY)

    local primaryUltCost = GetAbilityCost(ult1)
    local backupUltCost = GetAbilityCost(ult2)

    local ultiNeeded = math.max(primaryUltCost, backupUltCost)
    local current, maximum = GetUnitPower("player", POWERTYPE_ULTIMATE)

    return current, ultiNeeded, maximum
end

-- donate to me if you want to
function FastReset.donate()
    -- show message window
    SCENE_MANAGER:Show('mailSend')
    -- wait 200 ms async
    zo_callLater(
            function()
                -- fill out messagebox
                ZO_MailSendToField:SetText("@m00nyONE")
                ZO_MailSendSubjectField:SetText("Donation for FastReset")
                QueueMoneyAttachment(1)
                ZO_MailSendBodyField:TakeFocus()
            end,
            200)
end
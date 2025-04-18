-- server/zones.lua (control de captura y dominación por equipos)

local zoneState = {}
local playersInZones = {}
local captureTimers = {}
local zoneOwners = {}

-- Inicializar zonas
for i = 1, #Config.Zones do
    playersInZones[i] = {}
    zoneOwners[i] = nil
end

RegisterNetEvent('conquest:enteredZone')
AddEventHandler('conquest:enteredZone', function(zoneIndex)
    local src = source
    local team = exports['conquest-system']:getPlayerTeam(src)
    if not team then return end

    if not playersInZones[zoneIndex][src] then
        playersInZones[zoneIndex][src] = team
        checkZoneCapture(zoneIndex)
    end
end)

RegisterNetEvent('conquest:leftZone')
AddEventHandler('conquest:leftZone', function(zoneIndex)
    local src = source
    playersInZones[zoneIndex][src] = nil
    checkZoneCapture(zoneIndex)
end)

function checkZoneCapture(zoneIndex)
    local countRed, countBlue = 0, 0

    for _, team in pairs(playersInZones[zoneIndex]) do
        if team == 'Red' then countRed = countRed + 1 end
        if team == 'Blue' then countBlue = countBlue + 1 end
    end

    local dominant = nil
    if countRed - countBlue >= 2 then dominant = 'Red' end
    if countBlue - countRed >= 2 then dominant = 'Blue' end

    if dominant and not captureTimers[zoneIndex] then
        TriggerClientEvent('conquest:startCaptureVisual', -1, zoneIndex, dominant)

        captureTimers[zoneIndex] = SetTimeout(Config.CaptureTime * 1000, function()
            zoneOwners[zoneIndex] = dominant
            captureTimers[zoneIndex] = nil
            playersInZones[zoneIndex] = {}

            TriggerClientEvent('conquest:updateZoneOwnership', -1, zoneOwners)
            TriggerClientEvent('chat:addMessage', -1, {
                args = { '[Conquista]', ('%s ha capturado %s'):format(dominant, Config.Zones[zoneIndex].name) }
            })
        end)
    elseif not dominant and captureTimers[zoneIndex] then
        ClearTimeout(captureTimers[zoneIndex])
        captureTimers[zoneIndex] = nil
    end
end


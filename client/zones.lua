-- client/zones.lua (PolyZone + visualizador debug activado + CORRECTO uso de CircleZone)

CircleZone = CircleZone

local ZoneList = {}
local currentZone = nil
local insideZone = false
local captureTimer = 0
local captureActive = false

CreateThread(function()
    for i, zone in ipairs(Config.Zones) do
        local poly = CircleZone:Create(zone.coords, 15.0, {
            name = "conquest_zone_" .. i,
            useZ = false,
            debugPoly = true -- ✅ activa visualizador debug
        })

        poly:onPlayerInOut(function(isPointInside)
            if isPointInside then
                currentZone = i
                insideZone = true
                TriggerServerEvent('conquest:enteredZone', i)
                TriggerEvent('conquest:setZoneHUD', zone.name)
            else
                insideZone = false
                TriggerServerEvent('conquest:leftZone', i)
                currentZone = nil
            end
        end)

        table.insert(ZoneList, poly)
    end
end)

-- Actualiza HUD con la zona activa para más facha
RegisterNetEvent('conquest:setZoneHUD')
AddEventHandler('conquest:setZoneHUD', function(zoneName)
    TriggerEvent('conquest:updateHud', 0, 0, zoneName)
end)

-- Evento visual opcional: pulso cuando se está capturando
RegisterNetEvent('conquest:startCaptureVisual')
AddEventHandler('conquest:startCaptureVisual', function(zoneIndex, team)
    local name = Config.Zones[zoneIndex] and Config.Zones[zoneIndex].name or "Zona"
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName("⚔️ Tu equipo está capturando: " .. name)
    EndTextCommandThefeedPostMessagetext("CHAR_MP_MORS_MUTUAL", "CHAR_MP_MORS_MUTUAL", false, 8, "Conquista", "Captura activa")
    EndTextCommandThefeedPostTicker(false, true)
end)
local QBCore = exports['qb-core']:GetCoreObject()
local playerData = QBCore.Functions.GetPlayerData()
local myTeam = playerData and playerData.metadata and playerData.metadata.conquestTeam or nil
if not myTeam then
    print("[CLIENT][zones.lua] Ignorado por falta de equipo")
    return
end

CircleZone = CircleZone or nil
local conquestZones = {}

for i, zoneData in ipairs(Config.Zones) do
    local zone = CircleZone:Create(zoneData.coords, zoneData.radius, {
        name = "conquest_zone_" .. i,
        debugPoly = false
    })

    zone:onPlayerInOut(function(isInside)
        if isInside then
            TriggerServerEvent("conquest:enteredZone", i)
        else
            TriggerServerEvent("conquest:leftZone", i)
        end
    end)

    conquestZones[i] = zone
end

RegisterNetEvent('conquest:updateZoneOwnership')
AddEventHandler('conquest:updateZoneOwnership', function(ownership)
    for i, team in pairs(ownership) do
        updateZoneVisual(i, team)
    end
end)

function updateZoneVisual(index, team)
    -- Aquí podés aplicar efectos visuales como cambiar color del HUD, mostrar blips, etc.
    print(("[CLIENT][zones.lua] Zona %s ahora pertenece a: %s"):format(index, team))
end

-- client/blips.lua (actualizado sin GetEntityRoutingBucket)

local createdBlips = {}
local zoneBlipData = {}

RegisterNetEvent('conquest:showZoneBlips')
AddEventHandler('conquest:showZoneBlips', function(ownership)
    for _, b in pairs(createdBlips) do RemoveBlip(b) end
    createdBlips = {}

    for i, zone in ipairs(Config.Zones) do
        local blip = AddBlipForCoord(zone.coords.x, zone.coords.y, zone.coords.z)
        SetBlipSprite(blip, 161)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.8)
        SetBlipAsShortRange(blip, false)

        local owner = ownership and ownership[i] or nil
        if owner == 'Red' then
            SetBlipColour(blip, 1)
        elseif owner == 'Blue' then
            SetBlipColour(blip, 3)
        else
            SetBlipColour(blip, 0)
        end

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(zone.name)
        EndTextCommandSetBlipName(blip)

        table.insert(createdBlips, blip)
        zoneBlipData[i] = blip
    end
end)

RegisterNetEvent('conquest:updateZoneOwnership')
AddEventHandler('conquest:updateZoneOwnership', function(ownership)
    for i, team in pairs(ownership) do
        local blip = zoneBlipData[i]
        if DoesBlipExist(blip) then
            if team == 'Red' then
                SetBlipColour(blip, 1)
            elseif team == 'Blue' then
                SetBlipColour(blip, 3)
            else
                SetBlipColour(blip, 0)
            end
        end
    end
end)

-- Comando manual para testeo
RegisterCommand("mostrarzonas", function()
    TriggerEvent('conquest:showZoneBlips')
end)

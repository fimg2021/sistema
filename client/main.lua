local QBCore = exports['qb-core']:GetCoreObject()
local nearJoinPoint = false

CreateThread(function()
    while true do
        Wait(0)
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local dist = #(coords - Config.EntryPoint)

        if dist < 30.0 then
            DrawMarker(1, Config.EntryPoint.x, Config.EntryPoint.y, Config.EntryPoint.z - 1.0,
                0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.0, 50, 150, 255, 200, false, false, 2, false, nil, nil, false)
        end

        if dist < 1.5 then
            ShowHelpNotification("Presiona ~INPUT_CONTEXT~ para entrar a la batalla")
            if IsControlJustPressed(0, 38) then
                TriggerEvent("conquest:openMenu")
            end
        end
    end
end)

function ShowHelpNotification(msg)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

RegisterNetEvent("conquest:openMenu")
AddEventHandler("conquest:openMenu", function()
    lib.registerContext({
        id = 'conquest_team_select',
        title = 'Seleccionar Equipo',
        options = {
            {
                title = '🟥 Equipo Rojo',
                description = 'Únete al equipo rojo',
                icon = '🔥',
                onSelect = function()
                    TriggerServerEvent('conquest:joinTeam', 'Red')
                end
            },
            {
                title = '🟦 Equipo Azul',
                description = 'Únete al equipo azul',
                icon = '💧',
                onSelect = function()
                    TriggerServerEvent('conquest:joinTeam', 'Blue')
                end
            }
        }
    })

    lib.showContext('conquest_team_select')
end)

function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

RegisterNetEvent('conquest:teleportToArena')
AddEventHandler('conquest:teleportToArena', function(team)
    local coords = Config.TeamSpawn[team] or vector3(0.0, 0.0, 72.0)
    SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, false, false, false, true)
end)

RegisterNetEvent('conquest:setOutfit')
AddEventHandler('conquest:setOutfit', function(team)
    local appearance = {}
    if team == "Red" then
        appearance = {
            components = {
                {component_id = 11, drawable = 8, texture = 0, palette = 0},
                {component_id = 8, drawable = 15, texture = 0, palette = 0}
            }
        }
    else
        appearance = {
            components = {
                {component_id = 11, drawable = 5, texture = 0, palette = 0},
                {component_id = 8, drawable = 15, texture = 0, palette = 0}
            }
        }
    end
    exports['illenium-appearance']:setPedAppearance(appearance)
end)

AddEventHandler('baseevents:onPlayerDied', function()
    TriggerServerEvent('conquest:queueRespawn')
end)

AddEventHandler('baseevents:onPlayerKilled', function()
    TriggerServerEvent('conquest:queueRespawn')
end)

RegisterNetEvent('conquest:updateZoneOwnership')
AddEventHandler('conquest:updateZoneOwnership', function(ownership)
    local playerData = QBCore.Functions.GetPlayerData()
    local myTeam = playerData and playerData.metadata and playerData.metadata.conquestTeam or nil

    if not myTeam then
        print("[CLIENT] Ignorando updateZoneOwnership: jugador sin equipo")
        return
    end

    for i, team in pairs(ownership) do
        print("[CLIENT] Zona", i, "capturada por", team)
    end
end)

RegisterNetEvent('conquest:setClientTeam')
AddEventHandler('conquest:setClientTeam', function(team)
    local playerData = QBCore.Functions.GetPlayerData()
    if playerData and playerData.metadata then
        playerData.metadata.conquestTeam = team
    end
end)

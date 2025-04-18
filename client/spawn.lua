RegisterNetEvent('conquest:spawnPlayer')
AddEventHandler('conquest:spawnPlayer', function(team)
    local spawnPoint = Config.TeamSpawn[team]
    if not spawnPoint then return end

    DoScreenFadeOut(500)
    Wait(500)

    local ped = PlayerPedId()
    SetEntityCoords(ped, spawnPoint.x, spawnPoint.y, spawnPoint.z, false, false, false, true)
    NetworkResurrectLocalPlayer(spawnPoint.x, spawnPoint.y, spawnPoint.z, 0.0, true, false)
    SetEntityVisible(ped, true)
    FreezeEntityPosition(ped, false)
    ClearPedTasksImmediately(ped)

    Wait(500)
    DoScreenFadeIn(500)

    -- Cambiar ropa si tienes illenium-appearance
    TriggerEvent('illenium-appearance:client:forceOutfit', team == 'Red' and 1 or 2)

    -- Mostrar HUD, blips y activar dimensión si aplica
    TriggerEvent('conquest:showBattleBlips')
    TriggerEvent('conquest:updateHud', 0, 0, "Zona de Inicio")
end)

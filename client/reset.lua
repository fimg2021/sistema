-- client/reset.lua (manejo de final de partida y retorno al lobby)

RegisterNetEvent('conquest:resetHud')
AddEventHandler('conquest:resetHud', function()
    -- Ocultar HUD personalizado
    SendNUIMessage({ action = 'hideHud' })
    -- Alternativamente, puedes borrar datos si el HUD es persistente
end)

RegisterNetEvent('conquest:teleportToLobby')
AddEventHandler('conquest:teleportToLobby', function()
    DoScreenFadeOut(500)
    Wait(500)
    local ped = PlayerPedId()
    SetEntityCoords(ped, Config.EntryPoint.x, Config.EntryPoint.y, Config.EntryPoint.z, false, false, false, true)
    NetworkResurrectLocalPlayer(Config.EntryPoint.x, Config.EntryPoint.y, Config.EntryPoint.z, 0.0, true, false)
    Wait(500)
    DoScreenFadeIn(500)
end)
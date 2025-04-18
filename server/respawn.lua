local respawnQueue = {}

RegisterNetEvent('conquest:queueRespawn')
AddEventHandler('conquest:queueRespawn', function()
    local src = source
    table.insert(respawnQueue, src)
end)

CreateThread(function()
    while true do
        Wait(Config.RespawnInterval * 1000)

        for _, src in ipairs(respawnQueue) do
            local team = exports['conquest-system']:getPlayerTeam(src)
            if team then
                TriggerClientEvent('conquest:respawnNow', src, team)
            end
        end

        respawnQueue = {}
    end
end)



-- client/main.lua (añadir al final para capturar muerte)
AddEventHandler('baseevents:onPlayerDied', function()
    TriggerServerEvent('conquest:queueRespawn')
end)

AddEventHandler('baseevents:onPlayerKilled', function()
    TriggerServerEvent('conquest:queueRespawn')
end)

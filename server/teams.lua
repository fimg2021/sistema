-- server/teams.lua (asegura limpieza de estado al salir y validación robusta)

local players = {}

RegisterNetEvent('conquest:joinTeam', function(team)
    local src = source
    if not players[src] then players[src] = {} end

    local redCount, blueCount = getTeamCount("Red"), getTeamCount("Blue")
    if team == "Red" and redCount - blueCount >= Config.MaxTeamDiff then
        TriggerClientEvent('chat:addMessage', src, { args = { '^1[Conquista]', 'El equipo Rojo ya tiene demasiados jugadores.' } })
        return
    elseif team == "Blue" and blueCount - redCount >= Config.MaxTeamDiff then
        TriggerClientEvent('chat:addMessage', src, { args = { '^1[Conquista]', 'El equipo Azul ya tiene demasiados jugadores.' } })
        return
    end

    players[src].team = team
    players[src].stats = { captures = 0, defends = 0, mvp = 0 }

    TriggerClientEvent('conquest:teleportToArena', src, team)
    TriggerClientEvent('conquest:setOutfit', src, team)
end)

RegisterNetEvent('conquest:leaveTeam', function()
    local src = source
    players[src] = nil
    TriggerClientEvent('chat:addMessage', src, { args = { '[Conquista]', 'Has salido del equipo.' } })
end)

function getTeamCount(team)
    local count = 0
    for _, p in pairs(players) do
        if p.team == team then count = count + 1 end
    end
    return count
end

AddEventHandler('playerDropped', function()
    players[source] = nil
end)

exports('getPlayerTeam', function(id)
    return players[id] and players[id].team or nil
end)

exports('getAllPlayers', function()
    return players
end)

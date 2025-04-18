-- server/conquest.lua (actualizado para sincronizar HUD)
local zoneOwnership = {}
local teamPoints = {
    Red = 0,
    Blue = 0
}

local streaks = {
    Red = 0,
    Blue = 0
}

local playerStats = {}
local players = {} -- Aseguramos estado

RegisterNetEvent('conquest:zoneCaptured')
AddEventHandler('conquest:zoneCaptured', function(zoneIndex)
    local src = source
    local team = exports['conquest-system']:getPlayerTeam(src)
    if not team then return end

    if not zoneOwnership[zoneIndex] then
        zoneOwnership[zoneIndex] = team
        teamPoints[team] = teamPoints[team] + 1
        TriggerClientEvent('conquest:markZoneCaptured', -1, zoneIndex)
        TriggerClientEvent('chat:addMessage', -1, {
            args = { '[Conquista]', ('%s ha capturado %s'):format(team, Config.Zones[zoneIndex].name) }
        })

        updateStreaks(team)
        grantTeamPower(team, teamPoints[team])
        addCaptureStat(src)

        syncHudForAll(Config.Zones[zoneIndex].name)
        checkForVictory()
    end
end)

function syncHudForAll(zoneName)
    for _, id in pairs(GetPlayers()) do
        TriggerClientEvent('conquest:syncPoints', id, teamPoints.Red, teamPoints.Blue, zoneName)
    end
end

function addCaptureStat(playerId)
    if not playerStats[playerId] then
        playerStats[playerId] = { captures = 0, team = exports['conquest-system']:getPlayerTeam(playerId) or '??' }
    end
    playerStats[playerId].captures = playerStats[playerId].captures + 1
end

function updateStreaks(scoringTeam)
    local opposingTeam = (scoringTeam == "Red") and "Blue" or "Red"
    streaks[scoringTeam] = streaks[scoringTeam] + 1
    streaks[opposingTeam] = 0

    if streaks[scoringTeam] >= Config.BonusStreak then
        TriggerClientEvent('chat:addMessage', -1, {
            args = { '[Conquista]', ('%s ha logrado una racha de %s zonas. ¡Bonus activado!'):format(scoringTeam, Config.BonusStreak) }
        })

        TriggerClientEvent('conquest:applyTeamBonus', -1, scoringTeam, Config.BonusDuration)
        streaks[scoringTeam] = 0
    end
end

function grantTeamPower(team, points)
    for _, playerId in pairs(GetPlayers()) do
        if exports['conquest-system']:getPlayerTeam(playerId) == team then
            if points == 3 then
                TriggerClientEvent('conquest:activateRadar', playerId)
            elseif points == 5 then
                TriggerClientEvent('conquest:activateRefuerzo', playerId)
            elseif points == 7 then
                TriggerClientEvent('conquest:activateEMP', playerId)
            end
        end
    end
end

function checkForVictory()
    local totalCaptured = 0
    for _, _ in pairs(zoneOwnership) do totalCaptured = totalCaptured + 1 end

    if totalCaptured >= #Config.Zones then
        local winner = nil
        if teamPoints.Red > teamPoints.Blue then
            winner = 'Rojo'
        elseif teamPoints.Blue > teamPoints.Red then
            winner = 'Azul'
        else
            winner = 'Empate'
        end

        TriggerClientEvent('chat:addMessage', -1, {
            args = { '[Conquista]', ('Partida terminada. Ganador: %s'):format(winner) }
        })

        showFinalStats()
        resetGame()
    end
end

function showFinalStats()
    local finalData = {}
    for id, data in pairs(playerStats) do
        table.insert(finalData, {
            name = GetPlayerName(id) or ('Jugador %s'):format(id),
            captures = data.captures,
            team = data.team
        })
    end

    table.sort(finalData, function(a, b) return a.captures > b.captures end)

    for _, playerId in pairs(GetPlayers()) do
        TriggerClientEvent('conquest:showScoreboard', playerId, finalData)
    end
end

function resetGame()
    zoneOwnership = {}
    teamPoints = { Red = 0, Blue = 0 }
    streaks = { Red = 0, Blue = 0 }
    playerStats = {}

    TriggerClientEvent('chat:addMessage', -1, { args = { '[Conquista]', 'Zonas reiniciadas. Preparando nueva partida...' } })

    for _, playerId in pairs(GetPlayers()) do
        TriggerClientEvent('conquest:teleportToArena', playerId, nil)
        TriggerClientEvent('illenium-appearance:client:resetOutfit', playerId)
        TriggerClientEvent('chat:addMessage', playerId, {
            args = { '[Conquista]', 'Has sido devuelto al lobby. Esperando nueva partida...' }
        })
    end
end



RegisterNetEvent('conquest:simulateCapture')
AddEventHandler('conquest:simulateCapture', function(zoneIndex, team)
    local zoneName = Config.Zones[zoneIndex] and Config.Zones[zoneIndex].name or "zona desconocida"

    TriggerClientEvent('conquest:startCaptureVisual', -1, zoneIndex, team)
    Wait(Config.CaptureTime * 1000)
    TriggerClientEvent('conquest:updateZoneOwnership', -1, { [zoneIndex] = team })

    for _, id in pairs(GetPlayers()) do
        local pTeam = exports['sistema']:getPlayerTeam(id)
        if not pTeam then
            print("[SERVER] Ignorando jugador sin equipo:", GetPlayerName(id), id)
        else
            if pTeam == team then
                TriggerClientEvent('chat:addMessage', id, {
                    args = { '[Conquista]', ('¡Tu equipo ha capturado %s!'):format(zoneName) }
                })
                TriggerClientEvent('conquest:playSound', id, 'win')
            else
                TriggerClientEvent('chat:addMessage', id, {
                    args = { '[Conquista]', ('%s ha perdido el control de %s.'):format(pTeam, zoneName) }
                })
                TriggerClientEvent('conquest:playSound', id, 'lose')
            end
        end
    end
end)

-- 🔒 Asegurarse que el equipo se sincroniza con el cliente
RegisterNetEvent('conquest:joinTeam')
AddEventHandler('conquest:joinTeam', function(team)
    local src = source
    TriggerClientEvent('conquest:setClientTeam', src, team)
end)

-- Limpieza garantizada del equipo cuando el jugador cambia de recurso o se desconecta
AddEventHandler('playerDropped', function(reason)
    local src = source
    players[src] = nil
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        for _, id in pairs(GetPlayers()) do
            players[id] = nil
        end
    end
end)
-- Limpieza garantizada del equipo cuando el jugador cambia de recurso o se desconecta
AddEventHandler('playerDropped', function(reason)
    local src = source
    players[src] = nil
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        for _, id in pairs(GetPlayers()) do
            players[id] = nil
        end
    end
end)

local activeBonus = false
local bonusEndTime = 0

RegisterNetEvent('conquest:applyTeamBonus')
AddEventHandler('conquest:applyTeamBonus', function(team, duration)
    local myTeam = exports['conquest-system']:getPlayerTeam()
    if myTeam ~= team then return end

    activeBonus = true
    bonusEndTime = GetGameTimer() + (duration * 1000)

    SetRunSprintMultiplierForPlayer(PlayerId(), 1.2)
    TriggerEvent('chat:addMessage', {
        args = { '[Conquista]', '¡BONUS ACTIVADO! Velocidad aumentada.' }
    })

    CreateThread(function()
        while activeBonus do
            if GetGameTimer() >= bonusEndTime then
                activeBonus = false
                SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
                TriggerEvent('chat:addMessage', {
                    args = { '[Conquista]', 'Bonus finalizado.' }
                })
                break
            end
            Wait(1000)
        end
    end)
end)

exports('getPlayerTeam', function()
    local ped = PlayerPedId()
    local model = GetEntityModel(ped)
    if model == GetHashKey('mp_m_freemode_01') then
        local shirt = GetPedDrawableVariation(ped, 11)
        if shirt == 8 then return 'Red' elseif shirt == 5 then return 'Blue' end
    end
    return nil
end)
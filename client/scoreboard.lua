local showingScoreboard = false

RegisterNetEvent('conquest:showScoreboard')
AddEventHandler('conquest:showScoreboard', function(players)
    if showingScoreboard then return end
    showingScoreboard = true

    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "conquest-scoreboard",
        players = players
    })

    PlaySoundFrontend(-1, "ScreenFlash", "WastedSounds", true)

    CreateThread(function()
        Wait(15000)
        SetNuiFocus(false, false)
        showingScoreboard = false
    end)
end)

-- Puedes agregar un comando temporal para probarlo:
-- /testscoreboard
RegisterCommand("testscoreboard", function()
    local dummyData = {
        { name = "Jugador1", team = "Red", captures = 5 },
        { name = "Jugador2", team = "Blue", captures = 3 },
        { name = "Jugador3", team = "Red", captures = 2 },
        { name = "Jugador4", team = "Blue", captures = 1 }
    }
    TriggerEvent('conquest:showScoreboard', dummyData)
end, false)

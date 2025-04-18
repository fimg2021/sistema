-- client/hud.lua (modo épico activado y enlazado al server)
local redPoints, bluePoints = 0, 0
local currentZone = nil
local showHud = false
local blink = false

RegisterNetEvent('conquest:updateHud')
AddEventHandler('conquest:updateHud', function(red, blue, zone)
    redPoints = red
    bluePoints = blue
    currentZone = zone
    showHud = true
    blink = true
    CreateThread(function()
        Wait(3000)
        blink = false
    end)
end)

CreateThread(function()
    while true do
        Wait(0)
        if showHud then
            drawHudText("🟥 ROJO: " .. redPoints, 0.015, 0.015, 255, 50, 50, 255)
            drawHudText("🟦 AZUL: " .. bluePoints, 0.015, 0.045, 50, 120, 255, 255)
            if currentZone then
                local r = blink and math.random(180, 255) or 255
                local g = blink and math.random(180, 255) or 255
                local b = blink and math.random(180, 255) or 255
                drawHudText("⚔️ Zona en disputa: " .. currentZone, 0.015, 0.075, r, g, b, 255)
            end
        end
    end
end)

function drawHudText(text, x, y, r, g, b, a)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextScale(0.45, 0.45)
    SetTextDropShadow()
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextColour(r, g, b, a)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

-- GANCHO DESDE SERVER: Actualiza HUD con datos en tiempo real
RegisterNetEvent('conquest:syncPoints')
AddEventHandler('conquest:syncPoints', function(red, blue, zoneName)
    TriggerEvent('conquest:updateHud', red, blue, zoneName)
end)
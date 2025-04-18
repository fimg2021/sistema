-- client/hud.lua (modo épico activado y enlazado al server)
local redPoints, bluePoints = 0, 0
local currentZone = nil
local showHud = false
local blink = false
local QBCore = exports['qb-core']:GetCoreObject()

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



RegisterNetEvent('conquest:setZoneHUD')
AddEventHandler('conquest:setZoneHUD', function(zoneName)
    local playerData = QBCore.Functions.GetPlayerData()
    local myTeam = playerData and playerData.metadata and playerData.metadata.conquestTeam or nil
    if not myTeam then return end

    TriggerEvent('conquest:updateHud', 0, 0, zoneName)
end)

RegisterNetEvent('conquest:startCaptureVisual')
AddEventHandler('conquest:startCaptureVisual', function(zoneIndex, team)
    local playerData = QBCore.Functions.GetPlayerData()
    local myTeam = playerData and playerData.metadata and playerData.metadata.conquestTeam or nil
    if not myTeam then return end

    local name = Config.Zones[zoneIndex] and Config.Zones[zoneIndex].name or "Zona"
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName("⚔️ Tu equipo está capturando: " .. name)
    EndTextCommandThefeedPostMessagetext("CHAR_MP_MORS_MUTUAL", "CHAR_MP_MORS_MUTUAL", false, 8, "Conquista", "Captura activa")
    EndTextCommandThefeedPostTicker(false, true)
end)

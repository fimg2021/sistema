RegisterCommand("conquest_points", function(source, args, rawCommand)
    if not args[1] or not args[2] then
        print("Uso: /conquest_points [Red|Blue] [cantidad]")
        return
    end

    local team = args[1]:lower()
    local points = tonumber(args[2])

    if not (team == "red" or team == "blue") or not points then
        print("Parámetros inválidos. Usa: /conquest_points red|blue cantidad")
        return
    end

    TriggerEvent('conquest:adminAddPoints', team:sub(1,1):upper() .. team:sub(2):lower(), points)
end, true)

RegisterCommand("conquest_end", function(source, args, rawCommand)
    print("[ADMIN] Terminando la partida manualmente.")
    TriggerEvent('conquest:endGame')
end, true)

RegisterCommand("conquest_capture", function(source, args, rawCommand)
    local zone = tonumber(args[1])
    local team = args[2] and args[2]:lower()
    if not zone or not team or not (team == 'red' or team == 'blue') then
        print("Uso: /conquest_capture [zoneIndex] [red|blue]")
        return
    end

    local formattedTeam = team:sub(1,1):upper() .. team:sub(2):lower()
    TriggerEvent('conquest:simulateCapture', zone, formattedTeam)
end, true)

RegisterCommand("conquest_debug", function()
    print("========== ESTADO DE ZONAS ==========")
    for i, zone in ipairs(Config.Zones) do
        local name = zone.name or ("Zona " .. i)
        print(("Zona %d - %s"):format(i, name))
    end
end, true)
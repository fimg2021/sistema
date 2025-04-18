Config = {}

Config.Zones = {
    { name = "Zona del Dolor", coords = vector3(200.0, -800.0, 30.0), weather = "RAIN" },
    { name = "Callejón del Camping", coords = vector3(250.0, -750.0, 30.0), weather = "FOGGY" },
    { name = "Parque del Desbalance", coords = vector3(300.0, -700.0, 30.0), weather = "CLEAR" },
    { name = "Autopista de la Ira", coords = vector3(350.0, -650.0, 30.0), weather = "THUNDER" },
    { name = "Cancha de la Vergüenza", coords = vector3(400.0, -600.0, 30.0), weather = "FOGGY" },
    { name = "Mercado de las Lágrimas", coords = vector3(450.0, -550.0, 30.0), weather = "RAIN" },
    { name = "Tienda de Respawn", coords = vector3(500.0, -500.0, 30.0), weather = "CLEAR" },
    { name = "Avenida Lag", coords = vector3(550.0, -450.0, 30.0), weather = "THUNDER" },
    { name = "Terreno del Tilt", coords = vector3(600.0, -400.0, 30.0), weather = "RAIN" },
    { name = "Cima del Salado", coords = vector3(650.0, -350.0, 30.0), weather = "FOGGY" }
}

Config.TeamSpawn = {
    Red = vector3(100.0, -800.0, 30.0),
    Blue = vector3(100.0, -600.0, 30.0)
}

Config.EntryPoint = vector3(229.93, -802.09, 30.55) -- Punto para interactuar con "E"

Config.MaxTeamDiff = 2
Config.CaptureTime = 30 -- segundos
Config.BonusStreak = 3 -- zonas consecutivas
Config.BonusDuration = 60 -- segundos
Config.RespawnInterval = 20 -- segundos
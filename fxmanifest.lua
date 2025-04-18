fx_version 'cerulean'
game 'gta5'
lua54 'yes'

description 'Sistema de Conquista Multiequipo para FiveM (standalone)' 

dependency 'illenium-appearance'

ui_page 'html/index.html'

files {
  'html/index.html'
}

shared_script 'shared/config.lua'
shared_script '@ox_lib/init.lua'

client_scripts {
  '@PolyZone/client.lua',  -- Cargar el script principal de PolyZone
    '@PolyZone/BoxZone.lua', -- Definición de BoxZone
    '@PolyZone/CircleZone.lua', -- Definición de CircleZone
    '@PolyZone/ComboZone.lua', -- Definición de ComboZone
    '@PolyZone/EntityZone.lua', -- Definición de EntityZone
    '@PolyZone/PolyZone.lua', -- Definición de PolyZone
  'client/*.lua'
}

server_scripts {
  'server/*.lua',
}
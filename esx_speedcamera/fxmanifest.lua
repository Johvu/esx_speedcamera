fx_version 'adamant'

game 'gta5'

description 'Speedcamera'

version '1.0'

lua54 'yes'

server_scripts {
  'server/main.lua',
  'config.lua'
}

client_scripts {
  'client/main.lua',
  'config.lua'
}

shared_scripts {
  '@es_extended/imports.lua',
  'shared/main.lua'
}

--data_file "DLC_ITYP_REQUEST" "kamera1.ytyp"
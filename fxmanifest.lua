fx_version 'cerulean'
game 'gta5'
lua54 'yes'
description 'Redesign af Heino'
dependencies {
    'es_extended',
    'esx_license',
    'ox_lib',
    'ox_target',
    'jet-lib',
    'mani-keys'
}

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    '@jet-lib/init.lua',
    'client/main.lua',
    'client/politi.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

ui_page 'web/index.html'

files {
    'web/**/*'
}

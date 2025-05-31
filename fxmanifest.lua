fx_version 'adamant'
game 'gta5'
lua54 'yes'
author '777'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
}

client_scripts {
    'client.lua',
    'noclip.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'configSV.lua',
    'server.lua',
}


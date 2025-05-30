fx_version 'adamant'
game 'gta5'
lua54 'yes'
author 'Exstugent'

shared_scripts {
    '@ox_lib/init.lua',
    'config/config.lua',
}

client_scripts {
    'client/main.lua',
    'client/noclip.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'configSV.lua',
    'server/main.lua',
}

-- FOR MORE SCRIPTS
-- JOIN THE SVG SHOP DISCORD
-- https://discord.gg/r7bU89em7J
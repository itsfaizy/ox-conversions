fx_version 'cerulean'
game 'gta5'

author 'itsfaizy'
description 'qb-to-ox v1.0.1'
lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua'
}

client_scripts {
    'compat/*.lua'
}

dependencies {
    'ox_lib'
}

provides {
    'qb-input',
    'qb-menu'
}


-- 'qb-input to ox-lib - Credits: https://gist.github.com/Mkeefeus'
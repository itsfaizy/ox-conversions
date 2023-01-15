fx_version 'cerulean'
game 'gta5'

author 'faizy#6969'
description 'qb-input to ox-lib - Credits: https://gist.github.com/Mkeefeus'
lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
}

client_scripts {
	'compat/*.lua'
}

dependencies {
	'ox_lib',
}

provides {
    'qb-input',
}
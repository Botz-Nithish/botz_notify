fx_version 'cerulean'
game 'gta5'
lua54 'yes'

client_script 'client/main.lua'
server_script 'server/main.lua'

files {
    'ui/build/index.html',
    'ui/build/static/**/*.*',
}
shared_script '@ox_lib/init.lua'
ui_page 'ui/build/index.html'
    
fx_version 'cerulean'
game 'gta5'
use_fxv2_oal 'yes'

lua54 'yes'
author 'ManiMods'

-- ui_page 'http://localhost:5173/' -- Uncomment this if you are using Vite (live preview when developing)
ui_page 'web/build/index.html'

client_script 'client.lua'
server_script 'server.lua'
shared_script '@jet-lib/init.lua'

files {
    'config.lua',
    'web/build/index.html',
    'web/build/**/*'
}
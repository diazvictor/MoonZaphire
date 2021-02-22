--[[--
 @package   MoonZaphire
 @filename  src/init.lua
 @version   1.0
 @author    Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      22.02.2021 10:09:59 -04
]]

package.path = package.path .. ';./?/init.lua;lib/?.lua'
require 'lib'

--- I create a namespace (master class)
MoonZaphire = lgi.package("MoonZaphire")

-- I require my modules
require('app')
require('start')
require('login')
require('settings')
require('chat_list')
require('chat')
require('window')

--- Start the application
local App = MoonZaphire.App()
App:register()

return App:run(arg)

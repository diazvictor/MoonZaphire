#!/usr/bin/lua5.1
--[[--
 @package   MoonZaphire
 @filename  lib/init.lua
 @version   3.0
 @autor     Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      01.02.2021 16:47:50 -04
]]

require 'middleclass'
print("| 'middleclass' loaded successfully.")

json = require 'json'
print("| 'json' loaded successfully.")

utils = require 'utils'
print("| 'utils' loaded successfully.")

mqtt = require 'mosquitto'
print("| 'mosquitto' loaded successfully.")

local assert  = lgi.assert
local builder = Gtk.Builder()
local template = 'data/gtk/MoonZaphire.ui'

assert(builder:add_from_file(template), "The window file failed loading!")
ui = builder.objects

users = {}

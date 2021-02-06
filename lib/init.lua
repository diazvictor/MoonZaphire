#!/usr/bin/lua5.1
--[[--
 @package   MoonZaphire
 @filename  lib/init.lua
 @version   3.0
 @autor     Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      01.02.2021 16:47:50 -04
]]

json = require 'json'
print("| 'json' loaded successfully.")

utils = require 'utils'
print("| 'utils' loaded successfully.")

-- Load the GResource file
local Res = Gio.Resource.load("data/MoonZaphire.gresource")
Gio.resources_register(Res)
print("| 'Resources' loaded successfully.")

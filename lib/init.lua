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

local provider = Gtk.CssProvider()
provider:load_from_path('data/styles/custom.css')
print("| 'style css' loaded successfully.")
local screen = Gdk.Display.get_default_screen(Gdk.Display:get_default())
local GTK_STYLE_PROVIDER_PRIORITY_APPLICATION = 600
Gtk.StyleContext.add_provider_for_screen(
	screen, provider,
	GTK_STYLE_PROVIDER_PRIORITY_APPLICATION
)

users = {}
message_content = nil

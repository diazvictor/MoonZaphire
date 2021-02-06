--[[--
 @package   MoonZaphire
 @filename  main.lua
 @version   1.0
 @author    Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      05.02.2021 00:09:36 -04
]]

package.path = package.path .. ';lib/?.lua;src/?.lua'

-- I require the libraries I depend on
print("Loading libraries:")
lgi = require 'lgi'
print("| 'lgi' loaded successfully. (Thanks Pavouk!)")
GObject = lgi.GObject
print("|----- 'lgi.GObject' loaded successfully.")
Gtk = lgi.require('Gtk', '3.0')
print("|----- 'lgi.Gtk' loaded successfully.")
Gio = lgi.Gio
print("|----- 'lgi.Gio' loaded successfully.")
GLib = lgi.GLib
print("|----- 'lgi.GLib' loaded successfully.")
Gdk = lgi.Gdk
print("|----- 'lgi.Gdk' loaded successfully.")
Pango = lgi.Pango
print("|----- 'lgi.Gdk' loaded successfully.")

require 'init'
print("Libraries loaded!\n")

--- I create a namespace (master class)
MoonZaphire = lgi.package("MoonZaphire")

-- I require my modules
require('app')
require('start')
require('login.auth_user')
require('login.auth_host')
require('settings.contacts')
require('settings.general')
require('chat.roster')
require('window')

--- Start the application
local App = MoonZaphire.App()
App:register()

return App:run(arg)

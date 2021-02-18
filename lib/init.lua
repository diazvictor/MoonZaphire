#!/usr/bin/lua5.1
--[[--
 @package   MoonZaphire
 @filename  lib/init.lua
 @version   3.0
 @autor     Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      01.02.2021 16:47:50 -04
]]

-- I require the libraries I depend on
lgi = require 'lgi'
local log = lgi.log.domain('MoonZaphire')
log.message("'lgi' loaded successfully. (Thanks Pavouk!)")

GObject = lgi.GObject
log.message("'lgi.GObject' loaded successfully.")

Gtk = lgi.require('Gtk', '3.0')
log.message("'lgi.Gtk' loaded successfully.")

Gio = lgi.Gio
log.message("'lgi.Gio' loaded successfully.")

GLib = lgi.GLib
log.message("'lgi.GLib' loaded successfully.")

Gdk = lgi.Gdk
log.message("'lgi.Gdk' loaded successfully.")

GdkPixbuf = lgi.GdkPixbuf
log.message("'lgi.GdkPixbuf' loaded successfully.")

Pango = lgi.Pango
log.message("'lgi.Pango' loaded successfully.")

json = require 'json'
log.message("'json' loaded successfully.")

utils = require 'utils'
log.message("'utils' loaded successfully.")

-- Load the GResource file
local Res = Gio.Resource.load("data/com.github.diazvictor.MoonZaphire.gresource")
Gio.resources_register(Res)
log.message("'resources' loaded successfully.")

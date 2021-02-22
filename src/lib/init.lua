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

GObject = lgi.require('GObject', '2.0')
log.message("'lgi.GObject' loaded successfully.")

Gtk = lgi.require('Gtk', '3.0')
log.message("'lgi.Gtk' loaded successfully.")

Gio = lgi.require('Gio', '2.0')
log.message("'lgi.Gio' loaded successfully.")

GLib = lgi.require('GLib', '2.0')
log.message("'lgi.GLib' loaded successfully.")

Gdk = lgi.require('Gdk', '3.0')
log.message("'lgi.Gdk' loaded successfully.")

GdkPixbuf = lgi.require('GdkPixbuf', '2.0')
log.message("'lgi.GdkPixbuf' loaded successfully.")

Pango = lgi.require('Pango', '1.0')
log.message("'lgi.Pango' loaded successfully.")

-- @FIXME: Correct paths for local libraries
-- json = require 'json'
json = require 'cjson.safe'
log.message("'json' loaded successfully.")

utils = require 'utils'
log.message("'utils' loaded successfully.")

class = require('middleclass')
log.message("'middleclass' loaded successfully.")

-- Load the GResource file
local Res = Gio.Resource.load("../data/com.github.diazvictor.MoonZaphire.gresource")
Gio.resources_register(Res)
log.message("'resources' loaded successfully.")

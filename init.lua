#!/usr/bin/lua5.1
--[[--
 @package   Chateando
 @filename  init.lua
 @version   1.0
 @autor     Díaz Urbaneja Víctor Eduardo Diex <diaz.victor@openmailbox.org>
 @date      08.04.2019 15:40:38 -04
]]

require('lib.middleclass') -- la libreria middleclass me da soporte a OOP
local mqtt = require('mosquitto') -- la libreria que soporta el protocolo
local lgi = require('lgi') -- requiero esta libreria que me permitira usar GTK

local GObject = lgi.GObject -- parte de lgi
local GLib = lgi.GLib -- para el treeview

local Gtk = lgi.require('Gtk', '3.0') -- el objeto GTK

local assert = lgi.assert
local builder = Gtk.Builder()

assert(builder:add_from_file('MainWindow.ui'),"error al cargar el archivo") -- hago un debugger, si el archivo existe (true) enlaso el archivo "MainWindow.ui", si no existe (false) imprimo un error

local ui = builder.objects
local main_window = ui.main_window -- invoco la ventana con el id main_window
local about_window = ui.about_window -- invoco la ventana con el id about_window
local login_window = ui.login_window -- invoco la ventana con el id login_window

local  mensajes        		= builder:get_object("mensajes") -- invoco al TextView con el id mensajes

local  entry_mensaje 		= ui.entry_mensaje
local  entry_user    		= ui.entry_user
local  entry_password    	= ui.entry_password
local  entry_broker 		= ui.entry_broker
local  entry_port	    	= ui.entry_port
local  buffer          		= ui.buffer_mensajes

local  btn_enviar       	= ui.btn_enviar
local  btn_login 	      	= ui.btn_login
local  btn_cancel       	= ui.btn_cancel
#!/usr/bin/lua5.1
--[[--
 @package   Mosquitto
 @filename  init.lua
 @version   1.0
 @autor     Díaz Urbaneja Víctor Eduardo Diex <diaz.victor@openmailbox.org>
 @date      15:40:38 -04 2019
]]

require('lib.middleclass')              										-- la libreria middleclass me da soporte a OOP
local mqtt = require('mosquitto')     											-- la libreria que soporta el protocolo
local json = require('lib.json')     											-- la libreria que soporta json
local lgi = require('lgi')            											-- requiero esta libreria que me permitira usar GTK

local GObject = lgi.GObject             										-- parte de lgi
local GLib = lgi.GLib                  											-- para el treeview
local Gdk = lgi.Gdk                  											-- para el treeview
local Gtk = lgi.require('Gtk', '3.0')											-- el objeto GTK

local assert = lgi.assert
local builder = Gtk.Builder()

assert(builder:add_from_file('MainWindow.ui'), "error al cargar el archivo") 	-- hago un debugger, si este archivo existe (true) enlaso el archivo ejemplo.ui, si no existe (false) imprimo un error

local main_window = builder:get_object('main_window')          					-- invoco la ventana con el id main_window
local about_window = builder:get_object('about_window')        					-- invoco la ventana con el id about_window
local login_window = builder:get_object('login_window')        					-- invoco la ventana con el id login_window

local header_bar = builder:get_object('header_bar')
local list_users = builder:get_object('list_users')

local  messages = builder:get_object('mensajes')            					-- invoco al
local  entry_message = builder:get_object('entry_mensaje')      				-- invoco al boton con el id load_choser
local  entry_user = builder:get_object('entry_user')       						-- invoco al boton con el id load_choser
local  entry_password = builder:get_object('entry_password')    				-- invoco al boton con el id load_choser
local  entry_broker = builder:get_object('entry_broker')       					-- invoco al boton con el id load_choser
local  entry_port = builder:get_object('entry_port')       						-- invoco al boton con el id load_choser
local  entry_topic = builder:get_object('entry_topic')     						-- invoco al boton con el id load_choser
local  buffer = builder:get_object('buffer_mensajes')     						-- invoco al boton con el id btn_correr

local  btn_submit = builder:get_object('btn_enviar')          					-- invoco al boton con el id btn_cerrar
local  btn_about = builder:get_object('btn_about')          					-- invoco al boton con el id btn_cerrar
local  btn_login = builder:get_object('btn_login')          					-- invoco al boton con el id btn_cerrar
local  btn_cancel = builder:get_object('btn_cancel')        					-- invoco al boton con el id btn_cerrar

local broker_default = 'broker.mqtt.cool'  										-- el servidor por defecto
local port_default = '1883'   													-- el puerto por defecto
local keepalive = 60     														-- si me desconecto, ¿Cuanto tiempo esperar antes de recoenctar?
local qos = 2        															-- acuse de recibo
local username_default = 'mqtt_user' .. math.random(1, 100) 					-- usuario por defecto
local password_default = ''														-- contraseña por defecto
msg = nil

local usuarios = {}

user, pass = nil, nil


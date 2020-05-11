#!/usr/bin/lua5.1
--[[--
 @package   Mosquitto
 @filename  init.lua
 @version   1.0
 @autor     Díaz Urbaneja Víctor Eduardo Diex <diaz.victor@openmailbox.org>
 @date      15:40:38 -04 2019
]]

require('lib.middleclass')              						                -- la libreria middleclass me da soporte a OOP
local mqtt    = require('mosquitto')     						                -- la libreria que soporta el protocolo
local json    = require('lib.json')     						                -- la libreria que soporta json
local lgi     = require('lgi')            						                -- requiero esta libreria que me permitira usar GTK

local GObject = lgi.GObject             						                -- parte de lgi
local GLib    = lgi.GLib                  						                -- para el treeview
local Gdk     = lgi.Gdk                  						                -- para el treeview
local Gtk     = lgi.require('Gtk', '3.0')						                -- el objeto GTK

local assert  = lgi.assert
local builder = Gtk.Builder()

assert(builder:add_from_file('MainWindow.ui'), "error al cargar el archivo") 	-- hago un debugger, si este archivo existe (true) enlaso el archivo ejemplo.ui, si no existe (false) imprimo un error

local main_window     = builder:get_object('main_window')          				-- invoco la ventana con el id main_window
local about_window    = builder:get_object('about_window')        			    -- invoco la ventana con el id about_window
local login_window    = builder:get_object('login_window')        				-- invoco la ventana con el id login_window

local header_bar      = builder:get_object('header_bar')
local list_users      = builder:get_object('list_users')

local  messages       = builder:get_object('mensajes')            				-- invoco al
local  entry_message  = builder:get_object('entry_mensaje')      				-- invoco al boton con el id load_choser
local  entry_user     = builder:get_object('entry_user')       					-- invoco al boton con el id load_choser
local  entry_password = builder:get_object('entry_password')    				-- invoco al boton con el id load_choser
local  entry_broker   = builder:get_object('entry_broker')       				-- invoco al boton con el id load_choser
local  entry_port     = builder:get_object('entry_port')       					-- invoco al boton con el id load_choser
local  entry_topic    = builder:get_object('entry_topic')     					-- invoco al boton con el id load_choser
local  buffer         = builder:get_object('buffer_mensajes')     				-- invoco al boton con el id btn_correr

local  btn_submit     = builder:get_object('btn_enviar')          				-- invoco al boton con el id btn_cerrar
local  btn_about      = builder:get_object('btn_about')          				-- invoco al boton con el id btn_cerrar
local  btn_login      = builder:get_object('btn_login')          				-- invoco al boton con el id btn_cerrar
local  btn_cancel     = builder:get_object('btn_cancel')        				-- invoco al boton con el id btn_cerrar
local  mqtt_tray      = builder:get_object('mqtt_tray')        					-- invoco al boton con el id btn_cerrar

local broker_default = 'broker.mqtt.cool'  										-- el servidor por defecto
local port_default = '1883'   													-- el puerto por defecto
local keepalive = 60     														-- si me desconecto, ¿Cuanto tiempo esperar antes de recoenctar?
local qos = 2        															-- acuse de recibo
local username_default = 'mqtt_user' .. math.random(1, 100) 					-- usuario por defecto
entry_user.text = username_default												-- mostrar usuario aleatorio
local password_default = ''														-- contraseña por defecto
msg = nil

local usuarios = {}

user, pass = nil, nil

function user_list()
	list_users:clear()
	for i, item in pairs(usuarios) do
		list_users:append({
			item
		})
	end
end

function validate_logIn()
	username, password = entry_user.text, entry_password.text

	broker, port = entry_broker.text, entry_port.text

	if ( username ~= '' ) and ( password ~= '') then
		user, pass = username, password
		print( 'logeado con el usuario ' .. username .. ' y la contraseña ' .. password )
	elseif ( username ~= '' ) and ( password == '' ) then
		user, pass = username, password_default
		print( 'logeado con el usuario ' .. username .. ' y la contraseña ' .. password_default )
	elseif ( password ~= '' ) and ( username == '' ) then
		user, pass = username_default, password
		print( 'logeado con el usuario ' .. username_default .. ' y la contraseña ' .. password )
	elseif ( username == '' ) and ( password == '' ) or ( username == '' ) or ( password == '' ) then
		user, pass = username_default, password_default
		print( 'logeado con el usuario aleatorio ' .. username_default .. ' y la contraseña ' .. password_default .. ' por defecto' )
	else
		return false, 'fallo y no se por que'
	end

	client = mqtt.new( user .. '-lua', false )	--[[ La instancia de comunicacion  MQTT]]--
	if ( pass ) then
		client:login_set( user, pass )
	end

	if ( broker ~= '' ) and ( port ~= '' ) then
		print( 'conectado a ' .. broker .. ' con el puerto ' .. port )
		client:connect_async( broker, tonumber( port ), keepalive )
	elseif ( broker ~= '' ) and ( port == '') then
		print( 'conectado a ' .. broker .. ' por defecto con el puerto ' .. port_default )
		client:connect_async( broker, tonumber( port_default ), keepalive )
	elseif ( port ~= '' ) and ( broker == '' ) then
		print( 'conectado a ' .. broker_default .. ' por defecto con el puerto ' .. port )
		client:connect_async( broker_default, tonumber(port), keepalive )
	elseif ( broker == '') and ( port == '' ) then
		print( 'conectado al ' .. broker_default .. ' por defecto con el puerto ' .. port_default ..  ' por defecto' )
		client:connect_async( broker_default, tonumber( port_default ), keepalive )
	else
		return false, 'fallo y no se por que'
	end

	client.ON_MESSAGE = function ( mid, topic, payload )
		local connect = 'users/connect'
		local disconnect = 'users/disconnect'

		if ( topic == connect ) then
			table.insert( usuarios, payload )
			local message_connect = {
				user = '',
				msg = payload .. ' se ha unido al chat',
				time = os.date( '%H:%M:%S' )
			}
			client:publish( channel, json:encode( message_connect ) )
		end
		if ( topic == disconnect ) then
		    local message_disconnect = {
				user = '',
				msg = payload .. ' ha dejado el chat',
				time = os.date( '%H:%M:%S' )
			}
			for k, v in pairs(usuarios) do
				if ( v == payload ) then
					table.remove(usuarios, k)
				end
			end
			client:publish( channel, json:encode( message_disconnect ) )
		end
	    if ( payload ~= 'my payload' ) and ( topic ~= connect ) and ( topic ~= disconnect ) then
	        msg = json:decode( payload )
	    end
	end

	client:loop_start()
	channel = entry_topic.text

    client:subscribe( channel, 0 )
	header_bar.title = '#' .. channel

    client:subscribe( 'users/connect', 0 )
	client:publish( 'users/connect', user )
end

function btn_login:on_clicked()
	validate_logIn()

	login_window:hide()
	main_window:show_all()
end

entry_message:grab_focus()												-- al iniciar lo mantengo en estado focus (activo)
-- cuando se presione Enviar

function submit()
    local msje = tostring(entry_message.text)
    if ( msje ~= '' ) then                  							-- solo envio si hay mensaje
		local info = {
			user = user,
			msg = msje,
			time = os.date('%H:%M:%S')
		}
        client:publish( channel, tostring( json:encode( info ) ) )		-- mando el mensaje
        entry_message.text = '' 										--limpio el entry
    end
    entry_message:grab_focus()											-- lo mantengo siempre en estado focus (activo)
end

local mark = buffer:create_mark( nil, buffer:get_end_iter(), false )
GLib.timeout_add (
    GLib.PRIORITY_DEFAULT, 300,
	function ()
		if msg then
			if (msg.user == '') then
				buffer:insert(buffer:get_iter_at_mark(mark),
					'\n' ..
					('%s %s'):format(msg.time, msg.msg), -- esto es el mensaje recibido
				-1)
			else
				buffer:insert(buffer:get_iter_at_mark(mark),
					'\n' ..
					('%s [%s]: %s'):format(msg.time, msg.user, msg.msg), -- esto es el mensaje recibido
				-1)
			end
			messages:scroll_mark_onscreen(mark)
			msg = nil
		end
		return true
	end
)

function entry_message:on_key_release_event(env)
	-- al presionar la tecla Enter/Return
    if ( env.keyval  == Gdk.KEY_Return ) then
		-- llamo a la funcion de submit que envia un mensaje
		submit()
    end
end

-- poblar lista cada un segundo
GLib.timeout_add (
    GLib.PRIORITY_DEFAULT, 1000,
	function ()
		user_list()
		return true
	end
)

function btn_submit:on_clicked()
    submit()
end

function btn_about:on_clicked()
	about_window:run()
	about_window:hide()
end

local visible = false

function tray()
	visible = not visible
	if visible then
		main_window:show_all()
	else
		main_window:hide()
	end
end

function mqtt_tray:on_activate()
	tray()
end

function login_window:on_destroy()
	Gtk.main_quit()
end

function btn_cancel:on_clicked()
	Gtk.main_quit()
end

function main_window:on_destroy()
	client:subscribe( 'users/disconnect', 0 )
	client:publish( 'users/disconnect', user )

	client:unsubscribe( 'users/disconnect', 0 )
	client:unsubscribe( 'users/connect', 0 )

	client:unsubscribe( channel, 0 )

    client:disconnect()
    Gtk.main_quit()
end

login_window:show_all()
Gtk.main()

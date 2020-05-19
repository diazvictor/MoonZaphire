#!/usr/bin/lua5.1
--[[--
 @package   MoonZaphire
 @filename  init.lua
 @version   2.8
 @autor     Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      14.05.2020 21:25:45 -04
]]

CSD_ENABLED = true
if CSD_ENABLED then win = 'view/MainCSD.ui' else win = 'view/MainNoCSD.ui' end

      class   = require('lib.middleclass')              						-- la libreria middleclass me da soporte a OOP
local mqtt    = require('mosquitto')     						                -- la libreria que soporta el protocolo
local json    = require('lib.json')     						                -- la libreria que soporta json
local lgi     = require('lgi')            						                -- requiero esta libreria que me permitira usar GTK
				require('languages.init')										-- esta es la libreria de lenguajes

local GObject = lgi.GObject             						                -- parte de lgi
local GLib    = lgi.GLib                  						                -- para el treeview
local Gdk     = lgi.Gdk                  						                -- para el treeview
local Gtk     = lgi.require('Gtk', '3.0')						                -- el objeto GTK

local assert  = lgi.assert
local builder = Gtk.Builder()

assert(builder:add_from_file(win), "The window file failed loading!") 	        -- hago un debugger, si este archivo existe (true) enlaso el archivo ejemplo.ui, si no existe (false) imprimo un error

setLang("en_us")

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

local  btn_submit     = builder:get_object('btn_submit')          				-- invoco al boton con el id btn_cerrar
local  btn_about      = builder:get_object('btn_about')          				-- invoco al boton con el id btn_cerrar
local  btn_login      = builder:get_object('btn_login')          				-- invoco al boton con el id btn_cerrar
local  btn_cancel     = builder:get_object('btn_cancel')        				-- invoco al boton con el id btn_cerrar
local  mqtt_tray      = builder:get_object('mqtt_tray')        					-- invoco al boton con el id btn_cerrar

local possible_characters = 'abcdefghijklmnopqrstuvwyxz1234567890'              -- caracteres posibles para el generador de passwords
local broker_default = 'broker.mqtt.cool'  										-- el servidor por defecto
local port_default = '1883'   													-- el puerto por defecto
local keepalive = 60     														-- si me desconecto, ¿Cuanto tiempo esperar antes de recoenctar?
local qos = 2        															-- acuse de recibo
local username_default = 'MoonZaphire' .. math.random(1, 999) 					-- usuario por defecto
local topic_default = "users/chat"
entry_user.text = username_default												-- mostrar usuario aleatorio
entry_topic.text = topic_default
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


	--/////////////////////////////////////////////////////////////////////////////////////////////--

		builder:get_object('btn_submit').label = getLINE("send")
		builder:get_object('btn_login').label = getLINE("login")
		builder:get_object('btn_cancel').label = getLINE("cancel")

		builder:get_object('usuarios').title = getLINE("users")
		builder:get_object('label_user').label = getLINE("user")
		builder:get_object('label_pass').label = getLINE("password")
		builder:get_object('label_broker').label = getLINE("broker")
		builder:get_object('label_port').label = getLINE("port")
		builder:get_object('label_topic').label = getLINE("topic")

		builder:get_object('entry_user').placeholder_text = username_default
		builder:get_object('entry_password').placeholder_text = getLINE("funny_pasw") --this doesnt works for some reason

		builder:get_object('login_window').title = getLINE("login")

	--/////////////////////////////////////////////////////////////////////////////////////////////--

local function superpass()
	math.randomseed(os.time())
	local str = ""
	for x = 1, 16 do
		local rand = math.random(1, #possible_characters)
		local randUpper = math.random(1,2)
		if (randUpper == 2) then
			str = str .. possible_characters:sub(rand, rand):upper()
		else
			str = str .. possible_characters:sub(rand, rand):lower()
		end
	end
	return str
end

function validate_logIn()
	username, password = entry_user.text:gsub("%s", ""):gsub(" ", ""), entry_password.text

	broker, port = entry_broker.text, entry_port.text

	local _e = false
	if (#username < 1) then
		username = username_default
		local _e = getLINE("default")
	end
	if (#password < 1) then
		password = superpass()
		local _e = _e or getLINE("default")
	end

	user, pass = username, password
	print(getLINE("logged_as", {username, password, _e or " "}))

	--/////////////////////////////////////////////////////////////////////////////////////////////--

	client = mqtt.new( user .. '-lua', false )	--[[ La instancia de comunicacion  MQTT]]--
	if ( pass ) then
		client:login_set( user, pass )
	end

	local _e = false
	if (#broker < 1) then
		broker = broker_default
		local _e = getLINE("default")
	end
	if (#tostring(tonumber(port) or "") < 1) then
		port = port_default
		local _e = _e or getLINE("default")
	end

	client:connect_async( broker, tonumber(port), keepalive )
	print(getLINE("connected_to", {broker, port, _e or " "}))

	--/////////////////////////////////////////////////////////////////////////////////////////////--

	client.ON_MESSAGE = function ( mid, topic, payload )
		local connect = 'users/connect'
		local disconnect = 'users/disconnect'

		if ( topic == connect ) then
			table.insert( usuarios, payload )
		end
		if ( topic == disconnect ) then
			for k, v in pairs(usuarios) do
				if ( v == payload ) then
					table.remove(usuarios, k)
				end
			end
		end
	    if ( payload ~= 'my payload' ) and ( topic ~= connect ) and ( topic ~= disconnect ) then
	        msg = json:decode( payload )
	    end
	end

	client:loop_start()
	channel = entry_topic.text

    client:subscribe( channel, 0 )
	if CSD_ENABLED then
		header_bar.title = '#' .. channel
	else
		main_window.title = '#' .. channel
	end

    client:subscribe( 'users/connect', 0 )
	client:publish( 'users/connect', user )
	local message_connect = {
		user = '',
		msg = getLINE("joined", {user}),
		time = os.date( '%H:%M:%S' )
	}
	client:publish( channel, json:encode( message_connect ) )
end

function btn_login:on_clicked()
	validate_logIn()

	login_window:hide()
	main_window:show_all()
	mqtt_tray.visible = true
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
    if ( login_window.is_active == true ) or ( login_window.is_active == false ) then
		if ( visible ) then
			main_window:show_all()
        else
            main_window:hide()
        end
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
	local message_disconnect = {
		user = '',
		msg = getLINE("left", {user}),
		time = os.date( '%H:%M:%S' )
	}
	client:publish( channel, json:encode( message_disconnect ) )

	client:unsubscribe( 'users/disconnect', 0 )
	client:unsubscribe( 'users/connect', 0 )

	client:unsubscribe( channel, 0 )

    client:disconnect()
    Gtk.main_quit()
end

login_window:show_all()
Gtk.main()

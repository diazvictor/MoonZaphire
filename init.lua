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
local ui = builder.objects

setLang("en_us")

local possible_characters = 'abcdefghijklmnopqrstuvwyxz1234567890'              -- caracteres posibles para el generador de passwords
local broker_default = 'broker.mqtt.cool'  										-- el servidor por defecto
local port_default = '1883'   													-- el puerto por defecto
local keepalive = 60     														-- si me desconecto, ¿Cuanto tiempo esperar antes de recoenctar?
local qos = 2        															-- acuse de recibo
local username_default = 'MoonZaphire' .. math.random(1, 999) 					-- usuario por defecto
local topic_default = "users/chat"
ui.entry_user.text = username_default												-- mostrar usuario aleatorio
ui.entry_topic.text = topic_default
local password_default = ''														-- contraseña por defecto
msg = nil

local usuarios = {}

user, pass = nil, nil

function user_list()
	ui.list_users:clear()
	for i, item in pairs(usuarios) do
		ui.list_users:append({
			item
		})
	end
end

--/////////////////////////////////////////////////////////////////////////////////////////////--

ui.btn_submit.label = getLINE("send")
ui.btn_login.label = getLINE("login")
ui.btn_cancel.label = getLINE("cancel")

ui.users.title = getLINE("users")
ui.label_user.label = getLINE("user")
ui.label_pass.label = getLINE("password")
ui.label_broker.label = getLINE("broker")
ui.label_port.label = getLINE("port")
ui.label_topic.label = getLINE("topic")

ui.entry_user.placeholder_text = username_default
ui.entry_password.placeholder_text = getLINE("funny_pasw") --this doesnt works for some reason

ui.login_window.title = getLINE("login")

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
	username, password = ui.entry_user.text:gsub("%s", ""):gsub(" ", ""), ui.entry_password.text

	broker, port = ui.entry_broker.text, ui.entry_port.text

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
	client:will_set( 'users/disconnect', user , 0)

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
		elseif ( topic == disconnect ) then
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
	channel = ui.entry_topic.text

    client:subscribe( channel, 0 )
	if CSD_ENABLED then
		ui.header_bar.title = '#' .. channel
	else
		ui.main_window.title = '#' .. channel
	end

    client:subscribe( 'users/connect', 0 )
	client:subscribe( 'users/disconnect', 0 )

	client:publish( 'users/connect', user )
	local message_connect = {
		user = '',
		msg = getLINE("joined", {user}),
		time = os.date( '%H:%M:%S' )
	}
	client:publish( channel, json:encode( message_connect ) )
end

function ui.btn_login:on_clicked()
	validate_logIn()

	ui.login_window:hide()
	ui.main_window:show_all()
	ui.mqtt_tray.visible = true
end

ui.entry_message:grab_focus()												-- al iniciar lo mantengo en estado focus (activo)
-- cuando se presione Enviar

function submit()
    local msje = tostring(ui.entry_message.text)
    if ( msje ~= '' ) then                  							-- solo envio si hay mensaje
		local info = {
			user = user,
			msg = msje,
			time = os.date('%H:%M:%S')
		}
        client:publish( channel, tostring( json:encode( info ) ) )		-- mando el mensaje
        ui.entry_message.text = '' 										--limpio el entry
    end
    ui.entry_message:grab_focus()											-- lo mantengo siempre en estado focus (activo)
end

local mark = ui.buffer_messages:create_mark( nil, ui.buffer_messages:get_end_iter(), false )
GLib.timeout_add (
    GLib.PRIORITY_DEFAULT, 300,
	function ()
		if msg then
			if (msg.user == '') then
				ui.buffer_messages:insert(ui.buffer_messages:get_iter_at_mark(mark),
					'\n' ..
					('%s %s'):format(msg.time, msg.msg), -- esto es el mensaje recibido
				-1)
			else
				ui.buffer_messages:insert(ui.buffer_messages:get_iter_at_mark(mark),
					'\n' ..
					('%s [%s]: %s'):format(msg.time, msg.user, msg.msg), -- esto es el mensaje recibido
				-1)
			end
			ui.messages:scroll_mark_onscreen(mark)
			msg = nil
		end
		return true
	end
)

function ui.entry_message:on_key_release_event(env)
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

function ui.btn_submit:on_clicked()
    submit()
end

if CSD_ENABLED then
	function ui.btn_about:on_clicked()
		ui.about_window:run()
		ui.about_window:hide()
	end
else
	function ui.about_submenu:on_button_press_event()
		ui.about_window:run()
		ui.about_window:hide()
	end
	function ui.quit_submenu:on_button_press_event()
	    Gtk.main_quit()
	end
end

local visible = false

function tray()
	visible = not visible
    if ( ui.login_window.is_active == true ) or ( ui.login_window.is_active == false ) then
		if ( visible ) then
			ui.main_window:show_all()
        else
            ui.main_window:hide()
        end
    end
end

function ui.mqtt_tray:on_activate()
	tray()
end

function ui.login_window:on_destroy()
	Gtk.main_quit()
end

function ui.btn_cancel:on_clicked()
	Gtk.main_quit()
end

function ui.main_window:on_destroy()
    Gtk.main_quit()
end

ui.login_window:show_all()
Gtk.main()

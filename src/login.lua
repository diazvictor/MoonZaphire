--[[--
 @package    MoonZaphire
 @filename  src/MoonZaphire-login.lua
 @version   3.0
 @author    Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      01.02.2021 16:54:24 -04
]]

local username_default = 'MoonZaphire' .. math.random(1, 999)
local broker_default = 'broker.mqtt.cool'
local port_default = 1883
local channel_default = 'users/chat'
local keepalive = 60
local qos = 2
auth = {}

ui.username.text = username_default
ui.hostname.text, ui.port.text = broker_default, port_default
ui.channel.text = channel_default

ui.revealer:set_reveal_child(false)

function validate_user()
	local username, password, msg = ui.username.text:gsub("%s", ""):gsub(" ", ""), ui.password.text

	if (#username < 1) then
		msg = ('Please enter your username')
		ui.username:grab_focus()
		return false, msg
	end
	if (#password < 1) then
		password = nil
	end

	msg = ('You are logged in with user %s and password %s'):format(username, password or 'nil')
	return username, password, msg
end

function validate_host()
	local broker, port, channel = ui.hostname.text, ui.port.text, ui.channel.text

	if (#broker < 1) then
		msg = ('Please enter a host address')
		ui.hostname:grab_focus()
		return false, msg
	end
	if (#port < 1) then
		ui.port.text = tonumber(port_default)
	end
	if (#channel < 1) then
		msg = ('Please enter a channel')
		ui.channel:grab_focus()
		return false, msg
	end

	msg = ('You have connected to the server %s with port %d'):format(broker, port)
	return broker, port, msg
end

function auth_logIn()
	auth.username, auth.password, message_user = validate_user()

	client = mqtt.new(('%s-lua'):format(auth.username), false)
	client:will_set('users/disconnect', auth.username , 0)

	if (auth.password) then
		client:login_set(auth.username, auth.password)
	end

	auth.hostname, auth.port, message_host = validate_host()

	client:connect_async(auth.hostname, auth.port, keepalive)
	print(('INFO: %s\nINFO: %s'):format(message_user, message_host))

	client.ON_MESSAGE = function (mid, topic, payload)
		local connect = 'users/connect'
		local disconnect = 'users/disconnect'

		if (topic == connect) then
			table.insert(users, payload)
		elseif (topic == disconnect) then
			for k, v in pairs(users) do
				if (v == payload) then
					table.remove(users, k)
				end
			end
		end

	    if (topic ~= connect and topic ~= disconnect) then
	        message_content = json:decode(payload)
	    end
	end

	client.ON_LOG = function (level, string)
		print(('[%s] MQTT LOG: %d->%s\n'):format(os.date('%H:%M:%S'), level, string))
	end

	auth.channel = ui.channel.text
	client:subscribe(auth.channel, 0)
	ui.header_bar.title = '#' .. auth.channel

	client:subscribe('users/connect', 0)
	client:publish('users/connect', auth.username)
	local message_connect = {
		msg = ('@%s has joined the chat'):format(auth.username),
		time = os.date('%H:%M:%S')
	}
	client:publish(auth.channel, json:encode(message_connect))
	client:loop_start()
end

function ui.btn_next:on_clicked()
	local ok, msg = validate_user()
	if (not ok) then
		-- @TODO: añadir a la vista un mensaje
		print(('ERROR: %s'):format(msg))
		return false
	end
	ui.login:set_visible_child_name('auth_host')
end

function ui.btn_back:on_clicked()
	ui.login:set_visible_child_name('auth_user')
end

function ui.btn_login:on_clicked()
	local ok, msg = validate_host()
	if (not ok) then
		-- @TODO: añadir a la vista un mensaje
		print(('ERROR: %s'):format(msg))
		return false
	end
	auth_logIn()
	ui.pages:set_visible_child_name('chat')
end

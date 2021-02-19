
socket = require('socket')
---@see https://git.eclipse.org/r/paho/org.eclipse.paho.mqtt.lua.git
local mqtt = require 'paho.mqtt'
 
local Mqtt 		= class('Mqtt')
local client 	= nil

--- At the beginning of the class
function Mqtt:initialize(username,password,broker,topic)
	self.username 	= username
	self.password 	= password
	self.broker 	= broker
	self.topic 		= topic
end

function Mqtt:connect()
	client = mqtt.client.create(
		self.broker,1883,
		function(topic, payload)
			local msg = json.decode( payload )
			if ( msg.username == self.username ) then return end
			Mqtt:receive(nil,msg)
		end
	)

	-- El ID del cliente
	client:connect(self.username)
	-- La suscripcion
	client:subscribe({'users/chat'})

	--El loop
	GLib.timeout_add(
		GLib.PRIORITY_DEFAULT, 100,
		function ()
			client:handler()
			return true
		end
	)
end

function Mqtt:subscribe(topic)
    client:subscribe(topic)
end

function Mqtt:composer(message)
	self.msg = {
		username = self.username,
		message  = message
	}
	self.msg_js = json.encode(self.msg)
end

function Mqtt:send()
	MoonZaphire.ChatView:new_message {
		['type'] = 'to',
		message = self.msg.message,
		time = os.date('%H:%M:%S')
	}
	client:publish(self.topic, self.msg_js)
end

function Mqtt:receive(topic,msg)
	MoonZaphire.ChatView:new_message({
			['type'] 	= 'from',
			author   	=  msg.username,
			message 	=  msg.message,
			time 		=  os.date('%H:%M:%S')
	})
	collectgarbage()
end

function Mqtt:disconnect()
	client:destroy()
end

return Mqtt

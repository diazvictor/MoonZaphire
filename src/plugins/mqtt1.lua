
---@see https://github.com/flukso/lua-mosquitto
local mosquitto	= require('mosquitto')  
local Mqtt 		= class('Mqtt')
local client 	= nil
local QoS		= 2
local keep_alive= 60
local port		= 1883

--- At the beginning of the class
function Mqtt:initialize(username,password,broker,topic)
	self.username 	= username
	self.password 	= password
	self.broker 	= broker
	self.topic 		= topic
end

function Mqtt:connect()
	client = mosquitto.new( self.username , false)
	client.ON_MESSAGE = function ( mid, topic, payload )
		local msg = json.decode( payload )
		if ( msg.username == self.username ) then return end
		if ( msg.message and msg.username ) then
			Mqtt:receive(topic,msg)
		end
	end

	client.ON_CONNECT = function ()
		print("connected")
		client:subscribe(self.topic, QoS)
	end

	client.ON_DISCONNECT = function ()
		if (client:reconnect()) then
			print("REconnecting ..")
		end
	end

	client:connect(self.broker,port,keep_alive)

	GLib.timeout_add(
		GLib.PRIORITY_DEFAULT, 300,
		function ()
			client:loop(1)
			return true
		end
	)
end


function Mqtt:composer(message)
	self.msg = {
		username = self.username,
		message  = message
	}
	self.msg_js = json.encode(self.msg)
end


function Mqtt:send()
	MoonZaphire.ChatView:new_message({
		['type'] = 'to',
		message = self.msg.message,
		time = os.date('%H:%M:%S')
	})
	client:publish(self.topic, self.msg_js)
end


function Mqtt:receive(topic,msg)
	if ( msg.message and msg.username ) then
		MoonZaphire.ChatView:new_message({
				['type'] 	= 'from',
				author   	=  msg.username,
				message 	=  msg.message,
				time 		=  os.date('%H:%M:%S')
		})
	end
	collectgarbage('collect')
end

function Mqtt:disconnect()
	client:disconnect()
	client:destroy()
end

return Mqtt

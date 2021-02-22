
---@see https://github.com/flukso/lua-mosquitto
local mqtt		= require('mosquitto')  
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
	client=mqtt.new( self.username , false)
	client:will_set( 'users/disconnect', self.username , 0) -- borador
	--Suport to V5
	--client:option(
		--mqtt.OPT_PROTOCOL_VERSION,
		--mqtt.MQTT_PROTOCOL_V5
	--)

	client.ON_MESSAGE = function ( mid, topic, payload )
		local msg = json.decode( payload )
		if not msg then return end
		if ( msg.username == self.username ) then return end
		if ( msg.message and msg.username ) then
			Mqtt:receive(topic,msg)
		end
		collectgarbage('collect')
	end

	client.ON_CONNECT = function ()
		io.write("connected\n")
		client:subscribe(self.topic, QoS)
	end

	client.ON_DISCONNECT = function ()
		local ok, errno, errmsg
		repeat
			ok, errno, errmsg = client:reconnect()
			if (not ok) then
				io.write('ERROR ',errno, errmsg, "\n")
			else
				io.write("REconnecting ..\n")
			end
		until(ok == true)
	end

	client:connect(self.broker,port,keep_alive)

	GLib.timeout_add(GLib.PRIORITY_DEFAULT, 300,function ()
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
end

function Mqtt:disconnect()
	client:disconnect()
	client:destroy()
end

return Mqtt

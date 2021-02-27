
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


function Mqtt:send(topic)
	local current_time = os.time()
	MoonZaphire.ChatView:new_message({
		id 		 	= ('%s-%s'):format(self.msg.username, current_time),
		['type'] 	=  'to',
		to 		 	=  self.msg.username,
		from 	 	=  topic,
		message  	=  self.msg.message,
		time 	 	=  current_time
	})
	client:publish(topic, self.msg_js)
	print(topic .. ' -> ' .. self.msg_js)
end


function Mqtt:receive(topic,msg)
	if ( msg.message and msg.username ) then
		local current_time = os.time()
		MoonZaphire.ChatView:new_message({
			id			= ('%s-%s'):format(msg.username, current_time),
			['type'] 	=  'from',
			to 			=  msg.username,
			from 		=  topic,
			author   	=  msg.username,
			message 	=  msg.message,
			time 		=  current_time
		})
	end
end

function Mqtt:subscribe(topic)
	client:subscribe(topic, QoS)
end

function Mqtt:disconnect()
	client:disconnect()
	client:destroy()
end

return Mqtt

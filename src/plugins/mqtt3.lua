
---@see https://github.com/zaherm/lua-mosquitto.git
local mosquitto	= require('mosquitto')
local Mqtt 		= class('Mqtt')
local main_loop, client 	= nil

--- At the beginning of the class
function Mqtt:initialize(username,password,broker,topic)
	self.username 	= username
	self.password 	= password
	self.broker 	= broker
	self.topic 		= topic
end

function Mqtt:connect()
	client = mosquitto.new( self.username, false )
	--client:on("connect", function(rc, ud)
		--print("on:connect", rc)
	--end)
	client:on("message", function(msg)
		local msg = json.decode( msg.payload )
		if ( msg.username == self.username ) then return end
		Mqtt:receive(nil,msg)
	end)

	local ok, rc = client:connect(self.broker, 1883, 10, true)
	local mid = client:subscribe('users/chat', 1)

	GLib.timeout_add(
		GLib.PRIORITY_DEFAULT, 100,
		function ()
			client:loop(1, 1)
			return true
		end
	)

	--GLib.timeout_add_seconds(GLib.PRIORITY_DEFAULT, 1,function()
		--client:loop(1, 1)
		--return true
	--end)

end

function Mqtt:subscribe(topic,qos)
    client:subscribe(topic, qos)
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
	client:publish(self.topic, self.msg_js, 1, false)
end


function Mqtt:receive(topic,msg)
	MoonZaphire.ChatView:new_message({
		['type'] 	= 'from',
		author   	=  msg.username,
		message 	=  msg.message,
		time 		=  os.date('%H:%M:%S')
	})
end


function Mqtt:disconnect()
	client:disconnect()
end

return Mqtt

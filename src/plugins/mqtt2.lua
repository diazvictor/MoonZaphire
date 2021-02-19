
---@see https://github.com/tacigar/lua-mqtt.git
local mqtt		= require('mqtt')  
local Mqtt 		= class('Mqtt')
local client 	= nil
local buffer	= nil

--- At the beginning of the class
function Mqtt:initialize(username,password,broker,topic)
	self.username 	= username
	self.password 	= password
	self.broker 	= broker
	self.topic 		= topic
end


function onMessageArrived(topicName, message)
	local msg = json.decode( message.payload )
	buffer	= msg
end


function Mqtt:connect()
    client = mqtt.AsyncClient {
      serverURI = self.broker,
      clientID  = self.username,
    }
	client:setCallbacks(nil, onMessageArrived, nil)
    client:connect{}
	client:subscribe(self.topic, 2)

	GLib.timeout_add(
		GLib.PRIORITY_DEFAULT, 100,
		function ()
			if buffer then
				if ( buffer.username == self.username ) then
					buffer = nil
					return true
				end
				Mqtt:receive(nil,buffer)
				--MoonZaphire.ChatView:new_message({
						--['type'] 	= 'from',
						--author   	=  buffer.username,
						--message 	=  buffer.message,
						--time 		=  os.date('%H:%M:%S')
				--})
				buffer = nil
			end
			return true
		end
	)

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
	MoonZaphire.ChatView:new_message {
		['type'] = 'to',
		message = self.msg.message,
		time = os.date('%H:%M:%S')
	}
	client:publish(self.topic, {
		payload = self.msg_js,
		qos = 2,
		retained = false
	})
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
	client:disconnect(100)
	client:destroy()
end

return Mqtt

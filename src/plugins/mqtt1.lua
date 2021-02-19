
---@see https://github.com/flukso/lua-mosquitto
local mosquitto	= require('mosquitto')  
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
	client = mosquitto.new( self.username, false )
	client:connect_async(self.broker,1883,60)

	client.ON_MESSAGE = function ( mid, topic, payload )
		local msg = json.decode( payload )
		if ( msg.username == self.username ) then return end
		Mqtt:receive(topic,msg)
	end
	client:subscribe( 'users/chat', 2 )

	GLib.timeout_add(
		GLib.PRIORITY_DEFAULT, 300,
		function ()
			client:loop_read()
			return true
		end
	)

	--GLib.timeout_add_seconds(GLib.PRIORITY_DEFAULT, 1,function()
		--client:loop_read()
		--return true
	--end)

      -- Set up sensitive state on buttons according to current state.
      -- Note that this is forwarded to mainloop, because bus callback
      -- can be called in some side thread and Gtk might not like to
      -- be controlled from other than main thread on some platforms.
      --GLib.idle_add(GLib.PRIORITY_DEFAULT, function()
			
			--return GLib.SOURCE_REMOVE
      --end)

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
	client:disconnect()
	client:destroy()
end

return Mqtt

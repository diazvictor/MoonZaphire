---@FIXME not funciona como se espera, bloquea la APP
---@see https://github.com/xHasKx/luamqtt.git
local mqtt	= require('mqtt')
local Mqtt 		= class('Mqtt')
local client 	= nil


--MoonZaphire:class("mqtt", GObject.Object)

--- At the beginning of the class
function Mqtt:initialize(username,password,broker,topic)
	self.username 	= username
	self.password 	= password
	self.broker 	= broker
	self.topic 		= topic
	--print('ININININI',username,password,broker,topic)
end

--- When building the class
function Mqtt:connect()

	client = mqtt.client{
		uri = self.broker,
		-- NOTE: more about flespi tokens: https://flespi.com/kb/tokens-access-keys-to-flespi-platform
		username = self.username,
		clean = false,
		version = mqtt.v50,
	}

	client:on{
		connect = function(connack)
			if connack.rc ~= 0 then
				print("connection to broker failed:", connack:reason_string(), connack)
				return
			end
			client:subscribe{ topic="users/chat", qos=2, callback=nil}
		end,
	
		message = function(msg)
			--assert(client:acknowledge(msg))
			local msg2 = json.decode( msg.payload )
			if ( msg2.username == self.username ) then return end
			print(msg2.username,msg2.message, self.username)
			--Mqtt:receive(nil,msg2)

			MoonZaphire.ChatView:new_message({
					['type'] 	= 'from',
					author   	=  msg2.username,
					message 	=  msg2.message,
					time 		=  os.date('%H:%M:%S')
			})

			
			--print("received:", msg)
			---print("disconnecting...")
	--		assert(client:disconnect())
		end,
	
		error = function(err)
			print("MQTT client error:", err)
		end,
	}


	GLib.timeout_add(
		GLib.PRIORITY_DEFAULT, 500,
		function ()
			--mqtt.run_ioloop(client)
			mqtt.run_sync(client)
			return true
		end
	)
	client:subscribe{ topic="users/chat2", qos=2, callback=nil}

	--GLib.timeout_add_seconds(GLib.PRIORITY_DEFAULT, 1,function()
		--mqtt.run_ioloop(client)
		--return true
	--end)



end

--- When building the class
function Mqtt:composer(message)
	---el username
	--print(self.username,message,'SEND')
	self.msg = {
		username = self.username,
		message  = message
	}
	self.msg_js = json.encode(self.msg)
end

--- When building the class
function Mqtt:send()
    --local timeago = os.date('%H:%M')
	--local msg = json.decode(self.msg)
	MoonZaphire.ChatView:new_message {
		['type'] = 'to',
		message = self.msg.message,
		time = os.date('%H:%M:%S')
	}
	client:publish{
		topic = self.topic,
		payload = self.msg_js,
		qos = 1,
		properties = {
			payload_format_indicator = 1,
			content_type = "text/json",
		},
		user_properties = {
			hello = "world",
		},
	}
end


function Mqtt:receive(topic,msg)
	--print('MESAGE RECEIVE',self.username,topic,os.date('%H:%M'), msg.payload)
	--- @TODO verificar el ID del chat donde se va a escribir esto
	--print( ( msg.username == self.username ), msg.username , self.username , 'CHECK USER' )
	--if ( msg.username == self.username ) then return end
	MoonZaphire.ChatView:new_message({
			['type'] 	= 'from',
			author   	=  msg.username,
			message 	=  msg.message,
			time 		=  os.date('%H:%M:%S')
	})
	--client:disconnect()
	--return true	
end

return Mqtt

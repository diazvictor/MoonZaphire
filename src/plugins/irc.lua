-------- IRC module for MoonZaphire --------

---@see https://github.com/JakobOvrum/LuaIRC
local irc 		= require('irc')  
local IRC 		= class('IRC')

--- At the beginning of the class
function IRC:initialize(nick,server,channel)
	self.nick 		= nick
	self.server 	= server
	self.channel	= channel
end

function IRC:connect()
	client = irc.new { nick = self.nick }
	client:connect(self.server)
	client:join(self.channel)
	IRC:receive()
	
	GLib.timeout_add(GLib.PRIORITY_DEFAULT, 300, function ()
		client:think()
		return true
	end)
end

function IRC:send(message)
	MoonZaphire.ChatView:new_message({
		type = 'to',
		message = message,
		time = os.date("%H:%M"),
	})
	client:sendChat(self.channel, message)
end

function IRC:receive()
	client:hook("OnChat", function(user, channel, message)
	MoonZaphire.ChatView:new_message({
		type = 'from',
		message = message,
		time = os.date("%H:%M"),
		author  = user.nick
	})
	end)
end

function IRC:disconnect()
	client:disconnect()
end

return IRC

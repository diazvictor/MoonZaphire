--[[--
 @package   MoonZaphire
 @filename  chat/chat.lua
 @version   1.0
 @author    Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      05.02.2021 07:24:46 -04
]]

--- I create the Chat subclass of MoonZaphire
MoonZaphire:class('Chat', Gtk.Stack)

-- Global variables in this scope
local log

-- Debugging messages
log = lgi.log.domain('Chat')

--- At the beginning of the class
function MoonZaphire.Chat:_class_init(klass)
	--- I load the template
	klass:set_template_from_resource(
		'/com/github/diazvictor/MoonZaphire/data/ui/chat/chat.ui'
	)
	--- I add the desired elements to the template
	-- klass:bind_template_child_full('id', true, 0)
end

--- When building the class
function MoonZaphire.Chat:_init()
	-- Start template
	self:init_template()

	-- I load the template objects
	-- id = self:get_template_child(MoonZaphire.Chat, 'id')
	chat = self
end

--- This method creates a new chat
-- @param chatid string: chat id (this should be the channel where we will talk about)
-- @return true or false and an error message
-- @usage: MoonZaphire.Chat:new_chat('/chat/user/diazvictor')
function MoonZaphire.Chat:new_chat(chatid)
	local chat_exist = chat:get_child_by_name(chatid)
	if chat_exist then
		chat:set_visible_child_name(chatid)
		return false, 'The chat already exists'
	end
	chat_view = MoonZaphire.ChatView {
		id = chatid
	}
	chat_view.priv.chatname.label = chatid
	chat:add_named(
		chat_view
	, chatid)
	chat:set_visible_child_name(chatid)
	print('Subscribed: ' .. chatid)
	mzmqtt:subscribe(chatid)
	return true
end

--[[--
 @package   MoonZaphire
 @filename  chat_list/item.lua
 @version   1.0
 @author    Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      07.02.2021 04:41:31 -04
]]

--- I create the ChatListItem subclass of MoonZaphire
MoonZaphire:class('ChatListItem', Gtk.ListBoxRow)

--- At the beginning of the class
function MoonZaphire.ChatListItem:_class_init(klass)
	--- I load the template
	klass:set_template_from_resource(
		'/com/github/diazvictor/MoonZaphire/data/ui/chat_list/item.ui'
	)
	--- I add the desired elements to the template
	klass:bind_template_child_full('avatar', true, 0)
	klass:bind_template_child_full('chatname', true, 0)
	klass:bind_template_child_full('last_message', true, 0)
	klass:bind_template_child_full('box_message_number', true, 0)
	klass:bind_template_child_full('message_number', true, 0)
	klass:bind_template_child_full('time', true, 0)
end

--- When building the class
function MoonZaphire.ChatListItem:_init()
	-- Start template
	self:init_template()

	-- I load the template objects
	self.priv.chatname = self:get_template_child(MoonZaphire.ChatListItem, 'chatname')
	self.priv.avatar = self:get_template_child(MoonZaphire.ChatListItem, 'avatar')
	self.priv.last_message = self:get_template_child(MoonZaphire.ChatListItem, 'last_message')
	self.priv.box_message_number = self:get_template_child(MoonZaphire.ChatListItem, 'box_message_number')
	self.priv.message_number = self:get_template_child(MoonZaphire.ChatListItem, 'message_number')
	self.priv.time = self:get_template_child(MoonZaphire.ChatListItem, 'time')
end

--[[--
 @package   MoonZaphire
 @filename  chat/chat_view.lua
 @version   1.0
 @author    Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      09.02.2021 00:09:22 -04
]]

--- I create the ChatView subclass of MoonZaphire
MoonZaphire:class('ChatView', Gtk.Box)

--- At the beginning of the class
function MoonZaphire.ChatView:_class_init(klass)
	--- I load the template
	klass:set_template_from_resource(
		'/com/github/diazvictor/MoonZaphire/data/ui/chat/chat_view.ui'
	)
	--- I add the desired elements to the template
	klass:bind_template_child_full('btn_search', true, 0)
	klass:bind_template_child_full('switch_details', true, 0)
	klass:bind_template_child_full('chat_details', true, 0)
end

--- When building the class
function MoonZaphire.ChatView:_init()
	-- Start template
	self:init_template()

	-- I load the template objects
	btn_search = self:get_template_child(MoonZaphire.ChatView, 'btn_search')
	switch_details = self:get_template_child(MoonZaphire.ChatView, 'switch_details')
	chat_details = self:get_template_child(MoonZaphire.ChatView, 'chat_details')

	--- By clicking I search a chat list
	btn_search.on_toggled = function (self)
		if  (self.active) then
			MoonZaphire.ChatList:show_search(true)
		else
			MoonZaphire.ChatList:show_search(false)
		end
	end

	--- By pressing the button I show the chat details
	switch_details.on_toggled = function (self)
		chat_details:set_reveal_child(self.active)
	end
end

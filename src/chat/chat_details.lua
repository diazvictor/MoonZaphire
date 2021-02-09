--[[--
 @package   MoonZaphire
 @filename  chat/chat_details.lua
 @version   1.0
 @author    Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      09.02.2021 00:54:21 -04
]]

--- I create the ChatDetails subclass of MoonZaphire
MoonZaphire:class('ChatDetails', Gtk.Box)

--- At the beginning of the class
function MoonZaphire.ChatDetails:_class_init(klass)
	--- I load the template
	klass:set_template_from_resource(
		'/com/github/diazvictor/MoonZaphire/data/ui/chat/chat_details.ui'
	)
	--- I add the desired elements to the template
	-- klass:bind_template_child_full('id', true, 0)
end

--- When building the class
function MoonZaphire.ChatDetails:_init()
	-- Start template
	self:init_template()

	-- I load the template objects
	-- id = self:get_template_child(MoonZaphire.ChatDetails, 'id')
end

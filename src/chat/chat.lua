--[[--
 @package   MoonZaphire
 @filename  chat/chat.lua
 @version   1.0
 @author    Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      05.02.2021 07:24:46 -04
]]

--- I create the Chat subclass of MoonZaphire
MoonZaphire:class('Chat', Gtk.Stack)

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
end

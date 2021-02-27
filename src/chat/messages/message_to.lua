--[[--
 @package   MoonZaphire
 @filename  message_to.lua
 @version   1.0
 @author    Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      16.02.2021 23:02:51 -04
]]

--- I create the MessageTo subclass of MoonZaphire
MoonZaphire:class('MessageTo', Gtk.ListBoxRow)

--- At the beginning of the class
function MoonZaphire.MessageTo:_class_init(klass)
	--- I load the template
	klass:set_template_from_resource(
		'/com/github/diazvictor/MoonZaphire/data/ui/chat/messages/message_to.ui'
	)
	--- I add the desired elements to the template
	klass:bind_template_child_full('message', true, 0)
	klass:bind_template_child_full('time', true, 0)

	-- function klass:set_property (id, value, pspec)
		-- if id == 1 then
			-- self.priv.message = value:get_string()
		-- elseif id == 2 then
			-- self.priv.time = value:get_string()
		-- else
			-- GObject.OBJECT_WARN_INVALID_PROPERTY_ID(self, id, pspec)
		-- end
	-- end

	-- function klass:get_property(id, value, pspec)
		-- if id == 1 then
			-- value:set_string(self.priv.message)
		-- elseif id == 2 then
			-- value:set_string(self.priv.time)
		-- else
			-- GObject.OBJECT_WARN_INVALID_PROPERTY_ID(self, id, pspec)
		-- end
	-- end

	-- klass:install_property(1, GObject.ParamSpecString (
		-- 'message', 'Message', 'Message text', '',
		-- { GObject.ParamFlags.READWRITE }
	-- ))

	-- klass:install_property(2, GObject.ParamSpecString (
		-- 'time', 'Time', 'Message time', '',
		-- { GObject.ParamFlags.READWRITE }
	-- ))
end

--- When building the class
function MoonZaphire.MessageTo:_init()
	-- Start template
	self:init_template()

	-- I load the template objects
	self.priv.message = self:get_template_child(MoonZaphire.MessageTo, 'message')
	self.priv.time = self:get_template_child(MoonZaphire.MessageTo, 'time')

	-- GObject.Binding.bind_property(
		-- self, 'message',
		-- message, 'label',
		-- GObject.BindingFlags.DEFAULT
	-- )

	-- GObject.Binding.bind_property(
		-- self, 'time',
		-- time, 'label',
		-- GObject.BindingFlags.DEFAULT
	-- )
end

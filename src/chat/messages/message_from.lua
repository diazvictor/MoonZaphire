--[[--
 @package   MoonZaphire
 @filename  message_from.lua
 @version   1.0
 @author    Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      17.02.2021 01:40:36 -04
]]

--- I create the MessageFrom subclass of MoonZaphire
MoonZaphire:class('MessageFrom', Gtk.ListBoxRow)

--- At the beginning of the class
function MoonZaphire.MessageFrom:_class_init(klass)
	--- I load the template
	klass:set_template_from_resource(
		'/com/github/diazvictor/MoonZaphire/data/ui/chat/messages/message_from.ui'
	)
	--- I add the desired elements to the template
	klass:bind_template_child_full('author', true, 0)
	klass:bind_template_child_full('message', true, 0)
	-- klass:bind_template_child_full('avatar', true, 0)
	klass:bind_template_child_full('time', true, 0)

	-- function klass:set_property (id, value, pspec)
		-- if id == 1 then
			-- self.priv.author = value:get_string()
		-- elseif id == 2 then
			-- self.priv.message = value:get_string()
		-- elseif id == 3 then
			-- self.priv.avatar = value:get_object()
		-- elseif id == 3 then
			-- self.priv.time = value:get_string()
		-- else
			-- GObject.OBJECT_WARN_INVALID_PROPERTY_ID(self, id, pspec)
		-- end
	-- end

	-- function klass:get_property(id, value, pspec)
		-- if id == 1 then
			-- value:set_string(self.priv.author)
		-- elseif id == 2 then
			-- value:set_string(self.priv.message)
		-- elseif id == 3 then
			-- value:set_object(self.priv.avatar)
		-- elseif id == 3 then
			-- value:set_string(self.priv.time)
		-- else
			-- GObject.OBJECT_WARN_INVALID_PROPERTY_ID(self, id, pspec)
		-- end
	-- end

	-- klass:install_property(1, GObject.ParamSpecString (
		-- 'author', 'Author', 'Message author', '',
		-- { GObject.ParamFlags.READWRITE }
	-- ))

	-- klass:install_property(2, GObject.ParamSpecString (
		-- 'message', 'Message', 'Message text', '',
		-- { GObject.ParamFlags.READWRITE }
	-- ))

	-- klass:install_property(3, GObject.ParamSpecObject(
		-- "avatar", "Avatar", "Author avatar", GdkPixbuf.Pixbuf,
		-- { GObject.ParamFlags.READWRITE, GObject.ParamFlags.CONSTRUCT }
	-- ))

	-- klass:install_property(3, GObject.ParamSpecString (
		-- 'time', 'Time', 'Message time', '',
		-- { GObject.ParamFlags.READWRITE }
	-- ))
end

--- When building the class
function MoonZaphire.MessageFrom:_init()
	-- Start template
	self:init_template()

	-- I load the template objects
	self.priv.author = self:get_template_child(MoonZaphire.MessageFrom, 'author')
	self.priv.message = self:get_template_child(MoonZaphire.MessageFrom, 'message')
	self.priv.avatar = self:get_template_child(MoonZaphire.MessageFrom, 'avatar')
	self.priv.time = self:get_template_child(MoonZaphire.MessageFrom, 'time')

	-- GObject.Binding.bind_property(
		-- self, 'author',
		-- self.priv.author, 'label',
		-- GObject.BindingFlags.DEFAULT
	-- )

	-- GObject.Binding.bind_property(
		-- self, "avatar",
		-- self.priv.avatar, "pixbuf",
		-- GObject.BindingFlags.DEFAULT
	-- )

	-- GObject.Binding.bind_property(
		-- self, 'message',
		-- self.priv.message, 'label',
		-- GObject.BindingFlags.DEFAULT
	-- )

	-- GObject.Binding.bind_property(
		-- self, 'time',
		-- self.priv.time, 'label',
		-- GObject.BindingFlags.DEFAULT
	-- )
end

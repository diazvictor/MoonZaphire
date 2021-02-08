--[[--
 @package   MoonZaphire
 @filename  roster/member.lua
 @version   1.0
 @author    Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      07.02.2021 04:41:31 -04
]]

--- I create the Member subclass of MoonZaphire
MoonZaphire:class('Member', Gtk.ListBoxRow)

--- At the beginning of the class
function MoonZaphire.Member:_class_init(klass)
	--- I load the template
	klass:set_template_from_resource(
		'/com/github/diazvictor/MoonZaphire/data/ui/roster/member.ui'
	)
	--- I add the desired elements to the template
	klass:bind_template_child_full('fullname', true, 0)
	klass:bind_template_child_full('last_message', true, 0)
end

--- When building the class
function MoonZaphire.Member:_init()
	-- Start template
	self:init_template()

	-- I load the template objects
	self.priv.fullname = self:get_template_child(MoonZaphire.Member, 'fullname')
	self.priv.last_message = self:get_template_child(MoonZaphire.Member, 'last_message')
end

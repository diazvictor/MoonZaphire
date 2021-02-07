--[[--
 @package   MoonZaphire
 @filename  member.lua
 @version   1.0
 @author    Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      07.02.2021 04:41:31 -04
]]

--- I create the RosterMember subclass of MoonZaphire
MoonZaphire:class('RosterMember', Gtk.ListBoxRow)

--- At the beginning of the class
function MoonZaphire.RosterMember:_class_init(klass)
	--- I load the template
	klass:set_template_from_resource(
		'/com/github/diazvictor/MoonZaphire/data/ui/chat/member.ui'
	)
	--- I add the desired elements to the template
	-- klass:bind_template_child_full('roster', true, 0)
end

--- When building the class
function MoonZaphire.RosterMember:_init()
	-- Start template
	self:init_template()

	-- I load the template objects
	-- local roster = self:get_template_child(MoonZaphire.RosterMember, 'roster')
end

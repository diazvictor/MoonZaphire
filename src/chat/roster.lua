--[[--
 @package   MoonZaphire
 @filename  window.lua
 @version   1.0
 @author    Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      05.02.2021 07:24:46 -04
]]

--- I create the Roster subclass of MoonZaphire
MoonZaphire:class('Roster', Gtk.ScrolledWindow)

local roster

--- At the beginning of the class
function MoonZaphire.Roster:_class_init(klass)
	--- I load the template
	klass:set_template_from_resource(
		'/com/github/diazvictor/MoonZaphire/data/ui/chat/roster.ui'
	)
	--- I add the desired elements to the template
	klass:bind_template_child_full('roster', true, 0)
end

--- When building the class
function MoonZaphire.Roster:_init()
	-- Start template
	self:init_template()

	-- I load the template objects
	roster = self:get_template_child(MoonZaphire.Roster, 'roster')
end

function MoonZaphire.Roster:get()
	return roster
end

function MoonZaphire.Roster:add_member (id_member)
	local members = MoonZaphire.Roster:get()
	members:add(
		MoonZaphire.RosterMember {
			id = id_member
		}
	)
	return members
end

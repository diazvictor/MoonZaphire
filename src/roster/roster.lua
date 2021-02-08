--[[--
 @package   MoonZaphire
 @filename  roster/roster.lua
 @version   1.0
 @author    Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      05.02.2021 07:24:46 -04
]]

--- I create the Roster subclass of MoonZaphire
MoonZaphire:class('Roster', Gtk.Box)

--- I require the modules belonging to Roster
require('roster.member')

local items, search_box

--- At the beginning of the class
function MoonZaphire.Roster:_class_init(klass)
	--- I load the template
	klass:set_template_from_resource(
		'/com/github/diazvictor/MoonZaphire/data/ui/roster/roster.ui'
	)
	--- I add the desired elements to the template
	klass:bind_template_child_full('items', true, 0)
	klass:bind_template_child_full('search_box', true, 0)
	klass:bind_template_child_full('search', true, 0)
end

--- When building the class
function MoonZaphire.Roster:_init()
	-- Start template
	self:init_template()

	-- I load the template objects
	items = self:get_template_child(MoonZaphire.Roster, 'items')
	search_box = self:get_template_child(MoonZaphire.Roster, 'search_box')
	local search = self:get_template_child(MoonZaphire.Roster, 'search')

	search.on_key_release_event = function (self, env)
		if ( env.keyval  == Gdk.KEY_Return ) then
			if (self.text ~= '') then
				local id_member = tostring(os.time())
				local member = MoonZaphire.Roster:add_member(id_member)
				-- member.child.fullname.label = self.text
			end
		end
	end
end

function MoonZaphire.Roster:get()
	return items
end

function MoonZaphire.Roster:show_search(state)
	local str = type(state)
	local message = ('A boolean was expected and %s was passed.'):format(str)
	if type(state) == 'boolean' then
		search_box:set_reveal_child(state)
		return true
	end
	utils:show_log('SEARCH', 'warning', message)
	return false
end

function MoonZaphire.Roster:add_member (id_member)
	local member = MoonZaphire.Member {
		id = id_member
	}
	items:add(member)
	member.priv.fullname.label = ('User %s'):format(id_member)
	member.priv.last_message.label = 'Lorem ipsum dolor sit amet, consectetur'
	return member
end

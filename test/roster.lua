--[[--
 @package   MoonZaphire
 @filename  roster.lua
 @version   1.0
 @author    Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      03.02.2021 16:51:58 -04
]]

local roster = class('roster')

--- Random name generator
-- @return name_random, id_random
local function name_generator()
	math.randomseed(os.time())
	local random, name_random, id_random = math.random(1, 8)
	if random == 1 then
		name_random = 'Andreas Mann'
		id_random = 1
	elseif random == 2 then
		name_random = 'Mach Ramdhani'
		id_random = 2
	elseif random == 3 then
		name_random = 'Bagas Rhafi'
		id_random = 3
	elseif random == 4 then
		name_random = 'Saeput Rohman'
		id_random = 4
	elseif random == 5 then
		name_random = 'Muhamad Aldiansyah'
		id_random = 5
	elseif random == 6 then
		name_random = 'Filkri Ruslandi'
		id_random = 6
	elseif random == 7 then
		name_random = 'Marcellus O\'Conner'
		id_random = 7
	elseif random == 8 then
		name_random = 'Georgette Schiller'
		id_random = 8
	end
	return id_random, name_random
end

--- Method to create a new roster
-- @param name_chat string: the name of the chat
function roster:new_item(id_chat, name_chat)
	ui.roster:add(Gtk.ListBoxRow {
		visible = true,
		id = id_chat,
		selectable = true,
		height_request = 60,
		width_request = 100,
		Gtk.Box {
			visible = true,
			orientation = Gtk.Orientation.VERTICAL,
			halign = Gtk.Align.START,
			valign = Gtk.Align.CENTER,
			margin_left = 10,
			margin_right = 10,
			Gtk.Label {
				visible = true,
				id = 'name_chat',
				label = name_chat,
				halign = Gtk.Align.START,
			},
			Gtk.Label {
				visible = true,
				id = 'last_message',
				ellipsize = Pango.EllipsizeMode.END,
				label = 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed doeiusmod tempor incididunt ut labore et dolore',
				halign = Gtk.Align.START,
			}
		}
	})
	return id_chat
end

--- Method to delete a roster
-- @param listboxrow userdata: the list row
-- @return true or false
function roster:delete_item(listboxrow)
	if (not listboxrow) then
		return false
	end
	ui.list_chat:remove(listboxrow)
	return true
end

--- By clicking add a new roster
function ui.btn_new_roster:on_clicked()
	local id_random, name_random = name_generator()
	roster:new_item(id_random, name_random)
end

function ui.roster:on_row_activated(self)
	local id_chat = tostring(self.id)
	user_chat:new_chat(id_chat, 'USER' .. id_chat)
	ui.user_chat:set_visible_child_name(id_chat)
end

--- By clicking I delete a roster
function ui.btn_delete_roster:on_clicked()
	local listboxrow = ui.roster:get_selected_row()
	roster:delete_item(listboxrow)
end

return roster

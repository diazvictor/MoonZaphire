--[[--
 @package   MoonZaphire
 @filename  list-chat.lua
 @version   1.0
 @author    Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      03.02.2021 16:51:58 -04
]]

math.randomseed(os.time())
local list_chat = class('list_chat')

--- Random name generator
-- @return name_random, id_random
function name_generator()
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

--- Method to create a new chat
-- @param id_chat number: the chat id
-- @param name_chat string: the name of the chat
function list_chat:new_chat(id_chat, name_chat)
	ui.list_chat:add(Gtk.ListBoxRow {
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
end

--- Method to delete a chat
-- @param listboxrow userdata: the list row
-- @return true or false
function list_chat:delete_chat(listboxrow)
	if (not listboxrow) then
		return false
	end
	ui.list_chat:remove(listboxrow)
	return true
end

--- By clicking add a new chat
function ui.btn_new_chat:on_clicked()
	local id_random, name_random = name_generator()
	list_chat:new_chat(id_random, name_random)
	user_chat:new_chat(id_random, name_random)
	ui.user_chat:set_visible_child_name(id_random)
end

--- By clicking I delete a chat
function ui.btn_delete_chat:on_clicked()
	local listboxrow = ui.list_chat:get_selected_row()
	list_chat:delete_chat(listboxrow)
end

return list_chat

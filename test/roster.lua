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
function roster:new_member(info)
	local info = info or {}
	ui.roster:add(Gtk.ListBoxRow {
		visible = true,
		id = info.id_member,
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
				id = 'name_member',
				label = info.name_member,
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
	return info.id_member
end

--- Method to delete a member
-- @param listboxrow userdata: the list row
-- @return true or false
function roster:delete_member(member)
	if (not member) then
		return false
	end
	ui.roster:remove(member)
	ui.user_chat.child[tostring(member.id)]:destroy()
	return true
end

--- By clicking add a new roster
function ui.btn_new_roster:on_clicked()
	local id_random, name_random = name_generator()
	roster:new_member({
		id_member = id_random,
		name_member = name_random
	})
end

function ui.roster:on_row_activated(self)
	local id_chat = tostring(self.id)
	user_chat:new_chat(id_chat, 'USER' .. id_chat)
	ui.user_chat:set_visible_child_name(id_chat)
end

function ui.roster:on_button_press_event(event)
	local x = tonumber(event.x)
	local y = tonumber(event.y)
	local pthinfo = self:get_row_at_y(y)
	if (pthinfo and event.type == 'BUTTON_PRESS' and event.button == 3) then
		local id_item = ui.roster:get_selected_row()
		local menu = Gtk.Menu {
			Gtk.ImageMenuItem {
				id = "edit",
				label = "Editar",
				image = Gtk.Image {
					icon_name = "edit-symbolic"
				},
				on_activate = function()
					print(id_item)
				end
			},
			Gtk.SeparatorMenuItem {},
			Gtk.ImageMenuItem {
				id = "delete",
				label = "Borrar",
				image = Gtk.Image {
					icon_name = "edit-delete-symbolic"
				},
				on_activate = function()
					roster:delete_member(id_item)
				end
			}
		}
		if id_item then
			menu:attach_to_widget(ui.roster, null)
			menu:show_all()
			menu:popup(nil, nil, nil, event.button, event.time)
		end
	end
end

function ui.btn_show_menu:on_clicked ()
	ui.alert:add_overlay(ui.menu)
	utils:addClass(ui.menu, 'alert-dialog')
end

function ui.menu_items:on_row_activated (self)
	if (self.name == 'item_new_group') then
		utils:show_alert({
			message = 'The <b>new group</b> module is currently under development.',
			show_close = false,
			timeout = 3
		})
	elseif (self.name == 'item_contacts') then
		utils:show_alert({
			message = 'The <b>contacts</b> module is currently under development.',
			show_close = false,
			timeout = 3
		})
	elseif (self.name == 'item_settings') then
		utils:show_alert({
			message = 'The <b>settings</b> module is currently under development.',
			show_close = false,
			timeout = 3
		})
	elseif (self.name == 'item_back') then
		ui.alert:remove(ui.menu)
	end
end

--- By clicking I search a roster
function ui.btn_search_roster:on_toggled ()
	if  (ui.btn_search_roster.active) then
		ui.roster_search_box:set_reveal_child(true)
		ui.roster_search:grab_focus()
	else
		ui.roster_search_box:set_reveal_child(false)
	end
end

return roster

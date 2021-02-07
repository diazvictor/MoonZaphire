--[[--
 @package   MoonZaphire
 @filename  window.lua
 @version   1.0
 @author    Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      05.02.2021 07:24:46 -04
]]

--- I create the Roster subclass of MoonZaphire
MoonZaphire:class('Roster', Gtk.Box)

--- At the beginning of the class
function MoonZaphire.Roster:_class_init(klass)
	--- I load the template
	klass:set_template_from_resource(
		'/com/github/diazvictor/MoonZaphire/data/ui/chat/roster.ui'
	)
	--- I add the desired elements to the template
	klass:bind_template_child_full('btn_show_menu', true, 0)
	klass:bind_template_child_full('btn_new_member', true, 0)
	klass:bind_template_child_full('btn_search_roster', true, 0)
	klass:bind_template_child_full('roster', true, 0)
	klass:bind_template_child_full('roster_search_box', true, 0)
	klass:bind_template_child_full('roster_search', true, 0)
end

--- When building the class
function MoonZaphire.Roster:_init()
	-- Start template
	self:init_template()

	-- I load the template objects
	local btn_show_menu = self:get_template_child(MoonZaphire.Roster, 'btn_show_menu')
	local btn_search_roster = self:get_template_child(MoonZaphire.Roster, 'btn_search_roster')
	local roster = self:get_template_child(MoonZaphire.Roster, 'roster')
	local roster_search_box = self:get_template_child(MoonZaphire.Roster, 'roster_search_box')
	local roster_search = self:get_template_child(MoonZaphire.Roster, 'roster_search')
	local btn_new_member = self:get_template_child(MoonZaphire.Roster, 'btn_new_member')

	--- I add a new member to the roster
	function MoonZaphire.Roster:add_member (info)
		local info = info or {}
		roster:add(Gtk.ListBoxRow {
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
					id = 'name',
					label = info.name,
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

	--- Pressing the menu button
	btn_show_menu.on_clicked = function ()
		-- I create a modal
		background:add_overlay(
			MoonZaphire.Settings({
				id = 'Settings',
			})
		)
		utils:addClass(background.child.Settings, 'alert-dialog')
	end

	--- By clicking I search a roster
	btn_search_roster.on_toggled = function ()
		if (btn_search_roster.active) then
			roster_search_box:set_visible(true)
			roster_search_box:set_reveal_child(true)
			roster_search:grab_focus()
		else
			roster_search_box:set_reveal_child(false)
		end
	end

	btn_new_member.on_clicked = function ()
		utils:show_alert({
			message = 'The <b>roster</b> module is under development',
			show_close = false,
			timeout = 1
		})
		-- @TODO: For some reason I cannot use the add_contact method of the SettingsContacts class.
		-- local id_member = tostring(os.time())
		-- local name = ('USER %s'):format(id_member)
		-- MoonZaphire.Roster:add_member({
			-- id_member = id_member,
			-- name = name
		-- })
		-- MoonZaphire.SettingsContacts:add_contact({
			-- id_member = id_member,
			-- name = name
		-- })
	end
end

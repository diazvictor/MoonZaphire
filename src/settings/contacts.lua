--[[--
 @package   MoonZaphire
 @filename  settings/contacts.lua
 @version   1.0
 @author    Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      06.02.2021 03:26:05 -04
]]

--- I create the SettingsContacts subclass of MoonZaphire
MoonZaphire:class('SettingsContacts', Gtk.Box)

--- At the beginning of the class
function MoonZaphire.SettingsContacts:_class_init(klass)
	--- I load the template
	klass:set_template_from_resource(
		'/com/github/diazvictor/MoonZaphire/data/ui/settings/contacts.ui'
	)
	--- I add the desired elements to the template
	-- klass:bind_template_child_full('btn_close', true, 0)

	--- Miqueas says that here (_class_init) register a method/function
end

--- When building the class
function MoonZaphire.SettingsContacts:_init()
	-- Start template
	self:init_template()

	-- I load the template objects
	local search = self:get_template_child(
		MoonZaphire.SettingsContacts, 'search'
	)
	-- local list_contacts = self:get_template_child(
		-- MoonZaphire.SettingsContacts, 'list-contacts'
	-- )

	-- --- I add a new contact to the list
	-- @TODO: I can't use this method in other classes, but I can use someone
	-- else's methods e.g. MoonZaphireRoster:add_member()
	-- function MoonZaphire.SettingsContacts:add_contact(info)
		-- local info = info or {}
		-- list_contacts:add(Gtk.ListBoxRow {
			-- visible = true,
			-- id = info.id_member,
			-- selectable = true,
			-- height_request = 60,
			-- width_request = 100,
			-- Gtk.Box {
				-- visible = true,
				-- orientation = Gtk.Orientation.HORIZONTAL,
				-- spacing = 10,
				-- Gtk.Image {
					-- visible = true,
					-- icon_name = 'contact-new-symbolic',
					-- icon_size = 6
				-- },
				-- Gtk.Label {
					-- visible = true,
					-- label = info.name,
				-- }
			-- }
		-- })
	-- end

	-- --- I capture the event of a key (in this case the ENTER key).
	-- search.on_key_release_event = function (self, env)
		-- if ( env.keyval  == Gdk.KEY_Return ) then
			-- if (self.text ~= '') then
				-- utils:show_alert({
					-- title = self.text,
					-- message = 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed doeiusmod tempor incididunt ut labore et dolore magna aliqua.',
					-- show_close = false,
					-- timeout = 1
				-- })
				-- self.text = ''
			-- else
				-- return false
			-- end
			-- self:grab_focus()
		-- end
	-- end

	-- By pressing the
	-- btn_new.on_clicked = function ()
		-- utils:show_alert({
			-- message = 'This <b>module</b> is still under <b>development</b>',
			-- show_close = false,
			-- timeout = 1
		-- })
	-- end
end

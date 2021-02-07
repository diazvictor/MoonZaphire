--[[--
 @package   MoonZaphire
 @filename  menu.lua
 @version   1.0
 @author    Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      07.02.2021 06:06:17 -04
]]

--- I create the Settings subclass of MoonZaphire
MoonZaphire:class('Settings', Gtk.Box)

--- At the beginning of the class
function MoonZaphire.Settings:_class_init(klass)
	--- I load the template
	klass:set_template_from_resource(
		'/com/github/diazvictor/MoonZaphire/data/ui/settings/settings.ui'
	)
	--- I add the desired elements to the template
	klass:bind_template_child_full('btn_back', true, 0)
	klass:bind_template_child_full('title', true, 0)
	klass:bind_template_child_full('btn_close', true, 0)
	klass:bind_template_child_full('settings_menu', true, 0)
	klass:bind_template_child_full('settings_pages', true, 0)
	klass:bind_template_child_full('switch_dark_mode', true, 0)
end

--- When building the class
function MoonZaphire.Settings:_init()
	-- Start template
	self:init_template()

	-- I load the template objects
	local btn_back = self:get_template_child(
		MoonZaphire.Settings, 'btn_back'
	)
	local title = self:get_template_child(
		MoonZaphire.Settings, 'title'
	)
	local btn_close = self:get_template_child(
		MoonZaphire.Settings, 'btn_close'
	)
	local settings_menu = self:get_template_child(
		MoonZaphire.Settings, 'settings_menu'
	)
	local settings_pages = self:get_template_child(
		MoonZaphire.Settings, 'settings_pages'
	)
	local switch_dark_mode = self:get_template_child(
		MoonZaphire.Settings, 'switch_dark_mode'
	)

	title.label = 'Settings'
	-- By pressing the
	btn_back.on_clicked = function ()
		settings_pages:set_visible_child_name('settings_menu')
		btn_back.visible = false
		title.label = 'Settings'
	end

	-- By pressing the
	btn_close.on_clicked = function ()
		print('Action: close')
	end

	--- With this I can know if the dark variant of the current gtk theme is being used.
	local dark_mode = settings.gtk_application_prefer_dark_theme
	switch_dark_mode.active = dark_mode

	local function show_btn_back()
		local router = settings_pages:get_visible_child_name()
		if router == 'settings_menu' then
			btn_back.visible = false
			title.label = 'Settings'
		elseif router == 'contacts' then
			btn_back.visible = true
			title.label = 'Contacts'
		end
	end
	--- Events for the menu
	settings_menu.on_row_activated = function (self, listboxrow)
		local item = listboxrow:get_index()
		if item == 0 then
			print('group-page')
			-- settings_pages:set_visible_child_name('new_group')
		elseif (item == 1) then
			print('contact-page')
			settings_pages:set_visible_child_name('contacts')
		elseif (item == 2) then
			print('settigs-page')
			-- settings_pages:set_visible_child_name('settings')
		elseif (item == 3) then
			-- Toggle dark mode
			local dark_mode = not switch_dark_mode.active
			switch_dark_mode:set_state(dark_mode)
			settings.gtk_application_prefer_dark_theme = dark_mode
		elseif (item == 4) then
			print('languages-page')
			-- settings_pages:set_visible_child_name('languages')
		elseif (item == 5) then
			print('about-page')
			-- settings_pages:set_visible_child_name('about')
		end
		if item then
			show_btn_back()
		end
	end

	--- Toggle dark mode
	switch_dark_mode.on_notify.active = function (self)
		settings.gtk_application_prefer_dark_theme = self.active
	end
end


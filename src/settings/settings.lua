--[[--
 @package   MoonZaphire
 @filename  settings/settings.lua
 @version   1.0
 @author    Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      07.02.2021 06:06:17 -04
]]

--- I create the Settings subclass of MoonZaphire
MoonZaphire:class('Settings', Gtk.Box)

--- I require the modules belonging to Settings
require('settings.general')
require('settings.new_group')
require('settings.languages')
require('settings.contacts')
require('settings.about')
require('settings.profile')

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
	klass:bind_template_child_full('items', true, 0)
	klass:bind_template_child_full('settings_pages', true, 0)
	klass:bind_template_child_full('switch_dark_mode', true, 0)
	klass:bind_template_child_full('btn_profile', true, 0)
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
	local items = self:get_template_child(
		MoonZaphire.Settings, 'items'
	)
	local settings_pages = self:get_template_child(
		MoonZaphire.Settings, 'settings_pages'
	)
	local switch_dark_mode = self:get_template_child(
		MoonZaphire.Settings, 'switch_dark_mode'
	)
	local btn_profile = self:get_template_child(
		MoonZaphire.Settings, 'btn_profile'
	)
	title.label = 'Settings'

	-- By pressing the
	btn_back.on_clicked = function ()
		settings_pages:set_visible_child_name('main')
		btn_back.visible = false
		title.label = 'Settings'
	end

	--- By pressing the
	-- @TODO: Destroying it is not the best option
	-- but hiding it, you must remove the css style to give the fadeIn effect
	-- and this way it doesn't work.
	btn_close.on_clicked = function ()
		background.child.Settings:destroy()
	end

	btn_profile.on_clicked = function ()
		settings_pages:set_visible_child_name('profile')
		btn_back.visible = true
		title.label = 'Edit profile'
	end

	--- With this I can know if the dark variant of the current gtk theme is being used.
	-- local dark_mode = settings.gtk_application_prefer_dark_theme
	-- switch_dark_mode.active = dark_mode

	--- Events for the menu
	items.on_row_activated = function (self, listboxrow)
		local item = listboxrow:get_index()
		if item == 0 then
			settings_pages:set_visible_child_name('new_group')
			btn_back.visible = true
			title.label = 'New group'
		elseif (item == 1) then
			settings_pages:set_visible_child_name('contacts')
			btn_back.visible = true
			title.label = 'Contacts'
		elseif (item == 2) then
			settings_pages:set_visible_child_name('general')
			btn_back.visible = true
			title.label = 'General'
		elseif (item == 3) then
			--- Toggle dark mode
			-- @FIXME: Doing the toggle from here is more time consuming than
			-- expected (For a second it gives a slow effect).
			local dark_mode = not switch_dark_mode.active
			switch_dark_mode:set_state(dark_mode)
		elseif (item == 4) then
			settings_pages:set_visible_child_name('languages')
			btn_back.visible = true
			title.label = 'Languages'
		elseif (item == 5) then
			settings_pages:set_visible_child_name('about')
			btn_back.visible = true
			title.label = 'About'
		end
	end

	--- Toggle dark mode
	switch_dark_mode.on_notify.active = function (self)
		MoonZaphire.Window:toggle_theme(self.active)
	end
end

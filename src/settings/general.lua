--[[--
 @package   MoonZaphire
 @filename  window.lua
 @version   1.0
 @author    Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      06.02.2021 02:10:40 -04
]]

--- I create the Settings subclass of MoonZaphire
MoonZaphire:class('Settings', Gtk.Box)

--- At the beginning of the class
function MoonZaphire.Settings:_class_init(klass)
	--- I load the template
	klass:set_template_from_resource(
		'/com/github/diazvictor/MoonZaphire/data/ui/settings/general.ui'
	)
	--- I add the desired elements to the template
	klass:bind_template_child_full('settings_menu', true, 0)
	klass:bind_template_child_full('settings_pages', true, 0)
	klass:bind_template_child_full('btn_close', true, 0)
	klass:bind_template_child_full('toggle_dark_mode', true, 0)
end

--- When building the class
function MoonZaphire.Settings:_init()
	-- Start template
	self:init_template()
	self.visible = true
	-- I load the template objects
	local settings_menu = self:get_template_child(MoonZaphire.Settings, 'settings_menu')
	settings_pages = self:get_template_child(MoonZaphire.Settings, 'settings_pages')
	local btn_close = self:get_template_child(MoonZaphire.Settings, 'btn_close')
	local toggle_dark_mode = self:get_template_child(MoonZaphire.Settings, 'toggle_dark_mode')

	--- Close button
	btn_close.on_clicked = function ()
		background.child.Settings:destroy()
	end

	--- With this I can know if the dark variant of the current gtk theme is being used.
	local dark_mode = settings.gtk_application_prefer_dark_theme
	toggle_dark_mode.active = dark_mode

	--- Events for the menu
	settings_menu.on_row_activated = function (self, listboxrow)
		local item = listboxrow:get_index()
		if item == 0 then
			utils:show_alert({
				message = 'The <b>group</b> module is currently under development.',
				show_close = false,
				timeout = 1
			})
		elseif (item == 1) then
			settings_pages:set_visible_child_name('contacts')
		elseif (item == 2) then
			utils:show_alert({
				message = 'The <b>settings</b> module is currently under development.',
				show_close = false,
				timeout = 1
			})
		elseif (item == 3) then
			-- Toggle dark mode
			dark_mode = not dark_mode
			if dark_mode then
				toggle_dark_mode:set_state(true)
				settings.gtk_application_prefer_dark_theme = true
			else
				toggle_dark_mode:set_state(false)
				settings.gtk_application_prefer_dark_theme = false
			end
		end
	end

	--- Toggle dark mode
	toggle_dark_mode.on_notify['active'] = function (self)
		local dark_mode = self.active
		if (dark_mode) then
			settings.gtk_application_prefer_dark_theme = true
		else
			settings.gtk_application_prefer_dark_theme = false
		end
	end
end

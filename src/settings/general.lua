--[[--
 @package   MoonZaphire
 @filename  window.lua
 @version   1.0
 @author    Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      06.02.2021 02:10:40 -04
]]

--- I create the Settings subclass of MoonZaphire
MoonZaphire:class('SettingsGeneral', Gtk.Box)

--- At the beginning of the class
function MoonZaphire.SettingsGeneral:_class_init(klass)
	--- I load the template
	klass:set_template_from_resource(
		'/com/github/diazvictor/MoonZaphire/data/ui/settings/general.ui'
	)
end

--- When building the class
function MoonZaphire.SettingsGeneral:_init()
	-- Start template
	self:init_template()
	self.visible = true
	-- I load the template objects
	-- local settings_menu = self:get_template_child(MoonZaphire.Settings, 'settings_menu')
	-- settings_pages = self:get_template_child(MoonZaphire.Settings, 'settings_pages')
	-- local btn_close = self:get_template_child(MoonZaphire.Settings, 'btn_close')
	-- local toggle_dark_mode = self:get_template_child(MoonZaphire.Settings, 'toggle_dark_mode')
end

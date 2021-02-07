--[[--
 @package   MoonZaphire
 @filename  app.lua
 @version   1.0
 @author    Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      05.02.2021 01:07:57 -04
]]

--- I create the App subclass of MoonZaphire
MoonZaphire:class("App", Gtk.Application)

--- When building the application
function MoonZaphire.App:_init()
	self.application_id = "com.github.diazvictor.MoonZaphire"
end

--- When starting the application
function MoonZaphire.App:do_startup()
	self._parent.do_startup(self)

	-- I create a configuration
	settings = Gtk.Settings.get_default()

	-- Creates the window
	settings.gtk_application_prefer_dark_theme = true
	MoonZaphire.Window {
		application = self
	}
end

--- When activating the application
function MoonZaphire.App:do_activate()
	self.active_window:present()
end

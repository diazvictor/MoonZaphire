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
	-- I collect the value of the screen resolution
	local screen = Gdk.Screen:get_default()
	local width, height = screen:get_width(), screen:get_height()
	-- Creates the window
	MoonZaphire.Window {
		title = 'MoonZaphire',
		application = self,
		default_width = width,
		default_height = height
	}
end

--- When activating the application
function MoonZaphire.App:do_activate()
	self.active_window:present()
end

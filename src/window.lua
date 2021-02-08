--[[--
 @package   MoonZaphire
 @filename  window.lua
 @version   1.0
 @author    Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      05.02.2021 01:10:40 -04
]]

--- I create the Window subclass of MoonZaphire
MoonZaphire:class("Window", Gtk.Window)

--- At the beginning of the class
function MoonZaphire.Window:_class_init(klass)
	--- I load the template
	klass:set_template_from_resource(
		"/com/github/diazvictor/MoonZaphire/data/ui/window.ui"
	)

	--- I add the desired elements to the template
	klass:bind_template_child_full('background', true, 0)
	klass:bind_template_child_full('content', true, 0)
	klass:bind_template_child_full('login', true, 0)
	klass:bind_template_child_full('btn_menu', true, 0)
	klass:bind_template_child_full('btn_search', true, 0)
end

--- When building the class
function MoonZaphire.Window:_init()
	-- Start template
	self:init_template()

	-- I load the template objects
	-- @TODO: Find a way to inherit objects to other classes without declaring
	-- them as global classes
	background = self:get_template_child(MoonZaphire.Window, 'background')
	content = self:get_template_child(MoonZaphire.Window, 'content')
	content_login = self:get_template_child(MoonZaphire.Window, 'login')
	local btn_menu = self:get_template_child(MoonZaphire.Window, 'btn_menu')
	local btn_search = self:get_template_child(MoonZaphire.Window, 'btn_search')

	btn_menu.on_clicked = function (self)
		background:add_overlay(
			MoonZaphire.Settings {
				id = 'Settings'
			}
		)
		utils:addClass(background.child.Settings, 'alert-dialog')
	end

	--- By clicking I search a roster
	btn_search.on_toggled = function (self)
		if  (self.active) then
			MoonZaphire.Roster:show_search(true)
		else
			MoonZaphire.Roster:show_search(false)
		end
	end

	-- I load my css styles
	local styles = Gtk.CssProvider()
	styles:load_from_resource(
		'/com/github/diazvictor/MoonZaphire/data/styles/custom.css'
	)

	self:get_style_context().add_provider_for_screen(
		self:get_screen(self),
		styles,
		Gtk.STYLE_PROVIDER_PRIORITY_USER
	)
end

--[[--
 @package   MoonZaphire
 @filename  window.lua
 @version   1.0
 @author    Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      05.02.2021 01:10:40 -04
]]

--- I create the Start subclass of MoonZaphire
MoonZaphire:class('Start', Gtk.Box)

--- At the beginning of the class
function MoonZaphire.Start:_class_init(klass)
	--- I load the template
	klass:set_template_from_resource(
		'/com/github/diazvictor/MoonZaphire/data/ui/start.ui'
	)
	--- I add the desired elements to the template
	klass:bind_template_child_full('btn_go_register', true, 0)
	klass:bind_template_child_full('btn_go_login', true, 0)
	klass:bind_template_child_full('logo', true, 0)
end

--- When building the class
function MoonZaphire.Start:_init()
	-- Start template
	self:init_template()

	-- I load the template objects
	local btn_go_register = self:get_template_child(
		MoonZaphire.Start, 'btn_go_register'
	)
	local btn_go_login = self:get_template_child(
		MoonZaphire.Start, 'btn_go_login'
	)
	local logo = self:get_template_child(
		MoonZaphire.Start, 'logo'
	)
	--- I load the image and give it a specific size.
	logo.pixbuf = GdkPixbuf.Pixbuf.new_from_resource_at_scale(
		'/com/github/diazvictor/MoonZaphire/data/icons/scalable/apps/' ..
		'com.github.diazvictor.MoonZaphire.svg',
		250,
		250
	)
	-- By pressing the
	btn_go_register.on_clicked = function ()
		utils:show_alert({
			message = 'The <b>registration</b> module is currently under development.',
			show_close = true
		})
	end

	-- By pressing the
	btn_go_login.on_clicked = function ()
		content:set_visible_child_name('login')
	end
end

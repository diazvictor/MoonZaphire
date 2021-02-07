--[[--
 @package   MoonZaphire
 @filename  window.lua
 @version   1.0
 @author    Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      05.02.2021 01:10:40 -04
]]

--- I create the AuthUser subclass of MoonZaphire
MoonZaphire:class('AuthUser', Gtk.Box)

--- At the beginning of the class
function MoonZaphire.AuthUser:_class_init(klass)
	--- I load the template
	klass:set_template_from_resource(
		'/com/github/diazvictor/MoonZaphire/data/ui/login/auth_user.ui'
	)
	--- I add the desired elements to the template
	klass:bind_template_child_full('btn_next', true, 0)
end

--- When building the class
function MoonZaphire.AuthUser:_init()
	-- Start template
	self:init_template()

	-- I load the template objects
	local btn_next = self:get_template_child(MoonZaphire.AuthUser, 'btn_next')

	-- By pressing the
	btn_next.on_clicked = function ()
		content_login:set_visible_child_name('auth_host')
	end
end

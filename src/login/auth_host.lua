--[[--
 @package   MoonZaphire
 @filename  window.lua
 @version   1.0
 @author    Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      05.02.2021 01:10:40 -04
]]

--- I create the AuthHost subclass of MoonZaphire
MoonZaphire:class('AuthHost', Gtk.Box)

--- At the beginning of the class
function MoonZaphire.AuthHost:_class_init(klass)
	--- I load the template
	klass:set_template_from_resource(
		'/com/github/diazvictor/MoonZaphire/data/ui/login/auth_host.ui'
	)
	--- I add the desired elements to the template
	klass:bind_template_child_full('hostname', true, 0)
	klass:bind_template_child_full('channel', true, 0)
	klass:bind_template_child_full('revealer', true, 0)
	klass:bind_template_child_full('port', true, 0)
	klass:bind_template_child_full('btn_back', true, 0)
	klass:bind_template_child_full('btn_login', true, 0)
end

--- When building the class
function MoonZaphire.AuthHost:_init()
	-- Start template
	self:init_template()

	-- I load the template objects
	local hostname = self:get_template_child(MoonZaphire.AuthHost, 'hostname')
	local channel = self:get_template_child(MoonZaphire.AuthHost, 'channel')
	local port = self:get_template_child(MoonZaphire.AuthHost, 'port')
	local revealer = self:get_template_child(MoonZaphire.AuthHost, 'revealer')
	local btn_login = self:get_template_child(MoonZaphire.AuthHost, 'btn_login')
	local btn_back = self:get_template_child(MoonZaphire.AuthHost, 'btn_back')

	-- Hidden revealer
	revealer:set_reveal_child(false)

	-- By pressing the
	btn_back.on_clicked  = function ()
		content_login:set_visible_child_name('auth_user')
	end

	-- By pressing the
	btn_login.on_clicked  = function ()
		content:set_visible_child_name('chat')
	end
end


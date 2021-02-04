--[[--
 @package   MoonZaphire
 @filename  test/login.lua
 @version   1.0
 @author    Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      03.02.2021 16:30:53 -04
]]

ui.revealer:set_reveal_child(false)

function ui.btn_next:on_clicked()
	ui.login:set_visible_child_name('auth_host')
end

function ui.btn_back:on_clicked()
	ui.login:set_visible_child_name('auth_user')
end

function ui.btn_login:on_clicked()
	ui.pages:set_visible_child_name('chat')
end

function ui.btn_go_login:on_clicked()
	ui.pages:set_visible_child_name('login')
end

function ui.btn_go_register:on_clicked()
	utils:show_alert('El modulo de registro se encuentra en desarrollo')
end

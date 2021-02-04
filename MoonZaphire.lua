#!/usr/bin/lua5.1
--[[--
 @package   MoonZaphire
 @filename  src/init.lua
 @version   3.0
 @autor     Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      01.02.2021 16:49:49 -04
]]

package.path = package.path .. ';lib/?.lua'

print("Loading libraries:")
lgi = require 'lgi'
print("| 'lgi' loaded successfully. (Thanks Pavouk!)")
GObject = lgi.GObject
print("|----- 'lgi.GObject' loaded successfully.")
Gtk = lgi.require('Gtk', '3.0')
print("|----- 'lgi.Gtk' loaded successfully.")
Gio = lgi.Gio
print("|----- 'lgi.Gio' loaded successfully.")
GLib = lgi.GLib
print("|----- 'lgi.GLib' loaded successfully.")
Gdk = lgi.Gdk
print("|----- 'lgi.Gdk' loaded successfully.")
Pango = lgi.Pango
print("|----- 'lgi.Gdk' loaded successfully.")

require 'init'
print("Libraries loaded!\n")

-- MoonZaphire
require('test.login')
list_chat = require('test.list-chat')
user_chat = require('test.user-chat')

function ui.btn_test:on_clicked ()
	-- ui.chat:set_visible_child_name('2')
end

function ui.menu_about:on_clicked()
    ui.about_window:run()
    ui.about_window:hide()
end

function ui.menu_quit:on_clicked()
    Gtk.main_quit()
end

function ui.main_window:on_destroy()
    Gtk.main_quit()
end

ui.main_window:show_all()
Gtk.main()

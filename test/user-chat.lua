--[[--
 @package   MoonZaphire
 @filename  test/user-chat.lua
 @version   1.0
 @author    Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      03.02.2021 16:29:51 -04
]]

local user_chat = class('user_chat')

function user_chat:new_chat(id_chat, name_chat)
	local popover_more = Gtk.Popover {
		Gtk.Box {
			visible = true,
			width_request = 120,
			orientation = Gtk.Orientation.VERTICAL,
			Gtk.ModelButton {
				visible = true,
				id = 'delete_chat',
				text = 'Eliminar chat'
			},
			Gtk.Separator {
				visible = true,
				orientation = Gtk.Orientation.HORIZONTAL
			},
			Gtk.ModelButton {
				visible = true,
				id = 'empty_chat',
				text = 'Vaciar chat'
			}
		}
	}
	ui.user_chat:add_named(
		Gtk.Box {
			visible = true,
			orientation = Gtk.Orientation.VERTICAL,
			spacing = 20,
			Gtk.Box {
				visible = true,
				expand = false,
				orientation = Gtk.Orientation.VERTICAL,
				spacing = 10,
				Gtk.Box {
					visible = true,
					expand = false,
					orientation = Gtk.Orientation.HORIZONTAL,
					Gtk.Label {
						visible = true,
						expand = false,
						-- id = 'last_message',
						ellipsize = Pango.EllipsizeMode.END,
						label = name_chat,
						halign = Gtk.Align.START,
					},
					{
						Gtk.Box {
							visible = true,
							expand = false,
							orientation = Gtk.Orientation.HORIZONTAL,
							spacing = 10,
							Gtk.Button {
								visible = true,
								id = 'search',
								expand = true,
								relief = Gtk.ReliefStyle.NONE,
								Gtk.Image {
									visible = true,
									icon_name = 'search-symbolic'
								}
							},
							Gtk.Button {
								visible = true,
								id = 'view_right_pane',
								expand = true,
								relief = Gtk.ReliefStyle.NONE,
								Gtk.Image {
									visible = true,
									icon_name = 'view-right-pane-symbolic'
								}
							},
							Gtk.MenuButton {
								visible = true,
								id = 'more_menu',
								relief = Gtk.ReliefStyle.NONE,
								popover = popover_more,
								Gtk.Image {
									visible = true,
									icon_name = 'open-menu-symbolic'
								}
							}
						},
						pack_type = Gtk.PackType.END
					}
				},
				Gtk.Separator {
					visible = true,
					orientation = Gtk.Orientation.HORIZONTAL
				}
			},
			Gtk.ScrolledWindow {
				expand = false,
				visible = true,
				Gtk.Viewport {
					visible = true,
					Gtk.Box{
						visible = true
					}
				},
			},
			Gtk.Box {
				visible = true,
				expand = false,
				orientation = Gtk.Orientation.HORIZONTAL,
				Gtk.Entry {
					visible = true,
					expand = true,
					placeholder_text = 'Write a message...'
				},
				Gtk.Button {
					visible = true,
					id = 'send_message',
					expand = false,
					Gtk.Image {
						visible = true,
						icon_name = 'document-send-symbolic'
					}
				}
			}
		}
	, id_chat)
end

return user_chat

--[[--
 @package   MoonZaphire
 @filename  test/user-chat.lua
 @version   1.0
 @author    Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      03.02.2021 16:29:51 -04
]]

local user_chat = class('user_chat')

--- Method to send a message
-- @param id_chat: The id of the chat to which to send the message
-- @param message: The message
function user_chat:new_message(id_chat, message, origin)
	if not origin then
		origin = Gtk.Align.END
	else
		origin = Gtk.Align.START
	end
	local message = Gtk.Box {
		visible = true,
		id = 'message1',
		expand = false,
		orientation = Gtk.Orientation.HORIZONTAL,
		halign = origin,
		Gtk.Label {
			visible = true,
			expand = false,
			use_markup = true,
			wrap = true,
			lines = 1,
			selectable = true,
			label = message,
			halign = Gtk.Align.START,
		},
	}

	ui.user_chat.child[id_chat].child.message_box:add(
		message
	)
	local scrollBottom = ui.user_chat.child[id_chat].child.scroll
	local box_message = ui.user_chat.child[id_chat].child.message_box
	function box_message:on_size_allocate()
		local adj = scrollBottom:get_vadjustment()
		adj:set_value(adj.upper - adj.page_size)
	end
end

--- Method to create a chat
-- @param id_chat: The chat id, useful to get the chat information or delete it from the list.
-- @param name_chat: The title of the chat
function user_chat:new_chat(id_chat, name_chat)
	local popover_more = Gtk.Popover {
		Gtk.Box {
			visible = true,
			id = 'popover',
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
	local exist = ui.user_chat:get_child_by_name(id_chat)
	if exist then
		ui.user_chat:set_visible_child_name(id_chat)
		return false
	end
	ui.user_chat:add_named(
		Gtk.Box {
			visible = true,
			id = id_chat,
			orientation = Gtk.Orientation.VERTICAL,
			spacing = 20,
			Gtk.Box {
				visible = true,
				id = 'header',
				expand = false,
				orientation = Gtk.Orientation.VERTICAL,
				spacing = 10,
				Gtk.Box {
					visible = true,
					id = 'nav',
					expand = false,
					orientation = Gtk.Orientation.HORIZONTAL,
					Gtk.Label {
						visible = true,
						expand = false,
						id = 'title',
						ellipsize = Pango.EllipsizeMode.END,
						label = name_chat,
						halign = Gtk.Align.START,
					},
					{
						Gtk.Box {
							visible = true,
							id = 'tools',
							expand = false,
							orientation = Gtk.Orientation.HORIZONTAL,
							spacing = 10,
							Gtk.Button {
								visible = true,
								id = 'btn_search',
								expand = true,
								focus_on_click = false,
								relief = Gtk.ReliefStyle.NONE,
								Gtk.Image {
									visible = true,
									icon_name = 'search-symbolic'
								}
							},
							Gtk.Button {
								visible = true,
								id = 'btn_pane',
								expand = true,
								focus_on_click = false,
								relief = Gtk.ReliefStyle.NONE,
								Gtk.Image {
									visible = true,
									icon_name = 'view-right-pane-symbolic'
								}
							},
							Gtk.MenuButton {
								visible = true,
								id = 'btn_more_menu',
								focus_on_click = false,
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
				visible = true,
				id = 'scroll',
				expand = true,
				Gtk.Box {
					visible = true,
					id = 'message_box',
					orientation = Gtk.Orientation.VERTICAL,
					valign = Gtk.Align.END,
					spacing = 20
				}
			},
			Gtk.Box {
				visible = true,
				expand = false,
				id = 'controls',
				orientation = Gtk.Orientation.HORIZONTAL,
				Gtk.Entry {
					visible = true,
					id = 'message',
					expand = true,
					on_key_release_event = function (self, env)
						if ( env.keyval  == Gdk.KEY_Return ) then
							if (self.text ~= '') then
								user_chat:new_message(
									id_chat, tostring(self.text)
								)
								self.text = ''
							else
								return false
							end
							self:grab_focus()
						end
					end,
					placeholder_text = 'Write a message...'
				},
				Gtk.Button {
					visible = true,
					id = 'btn_send',
					expand = false,
					on_clicked = function ()
						local message = ui.user_chat.child[id_chat].child.message
						if (message.text ~= '') then
							print(message.text)
							user_chat:new_message(
								id_chat, tostring(message.text)
							)
							message.text = ''
						else
							return false
						end
						message:grab_focus()
					end,
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

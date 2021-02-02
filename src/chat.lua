--[[--
 @package   MoonZaphire
 @filename  chat.lua
 @version   3.0
 @author    Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      01.02.2021 18:48:25 -04
]]

function user_list()
	ui.list_users:clear()
	for _, item in pairs(users) do
		ui.list_users:append({
			item
		})
	end
end

ui.message:grab_focus()

function send_message()
	local message = tostring(ui.message.text)
	if (message ~= '') then
		message_content = {
			user = auth.username,
			msg = message,
			time = os.date('%H:%M:%S')
		}
		client:publish(auth.channel, tostring(json:encode(message_content)))
		ui.message.text = ''
	else
		return false
	end
	ui.message:grab_focus()
end

local mark = ui.buffer_messages:create_mark(nil, ui.buffer_messages:get_end_iter(), false)
GLib.timeout_add (
	GLib.PRIORITY_DEFAULT, 300,
	function ()
		if message_content then
			if (message_content.user == nil) then
				ui.buffer_messages:insert(ui.buffer_messages:get_iter_at_mark(mark),
					'\n' ..
					('%s %s'):format(message_content.time, message_content.msg),
				-1)
			end
			if (message_content.user) then
				ui.buffer_messages:insert(ui.buffer_messages:get_iter_at_mark(mark),
					'\n' ..
					('%s [%s]: %s'):format(message_content.time, message_content.user, message_content.msg),
				-1)
			end
			ui.messages:scroll_mark_onscreen(mark)
			message_content = nil
		end
		return true
	end
)

function ui.message:on_key_release_event(env)
	if ( env.keyval  == Gdk.KEY_Return ) then
		send_message()
	end
end

GLib.timeout_add (
	GLib.PRIORITY_DEFAULT, 1000,
	function ()
		user_list()
		return true
	end
)

function ui.btn_send:on_clicked()
	send_message()
end

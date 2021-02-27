--[[--
 @package   MoonZaphire
 @filename  chat/chat_view.lua
 @version   1.0
 @author    Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      09.02.2021 00:09:22 -04
]]

--- I create the ChatView subclass of MoonZaphire
MoonZaphire:class('ChatView', Gtk.Box)

-- Global variables in this scope
-- local message_box, scroll_box, log, scroll_down
local log, scroll_down

-- Debugging messages
log = lgi.log.domain('ChatView')

--- At the beginning of the class
function MoonZaphire.ChatView:_class_init(klass)
	--- I load the template
	klass:set_template_from_resource(
		'/com/github/diazvictor/MoonZaphire/data/ui/chat/chat_view.ui'
	)
	--- I add the desired elements to the template
	klass:bind_template_child_full('chatname', true, 0)
	klass:bind_template_child_full('btn_search', true, 0)
	klass:bind_template_child_full('switch_details', true, 0)
	klass:bind_template_child_full('chat_details', true, 0)

	klass:bind_template_child_full('scroll_box', true, 0)
	klass:bind_template_child_full('message_box', true, 0)
	klass:bind_template_child_full('message_scroll', true, 0)
	klass:bind_template_child_full('message_text', true, 0)
	klass:bind_template_child_full('buffer_message', true, 0)
	klass:bind_template_child_full('btn_send', true, 0)
end

--- When building the class
function MoonZaphire.ChatView:_init()
	-- Start template
	self:init_template()

	-- I load the template objects
	self.priv.chatname = self:get_template_child(MoonZaphire.ChatView, 'chatname')
	local btn_search = self:get_template_child(MoonZaphire.ChatView, 'btn_search')
	local switch_details = self:get_template_child(MoonZaphire.ChatView, 'switch_details')
	local chat_details = self:get_template_child(MoonZaphire.ChatView, 'chat_details')

	self.priv.scroll_box = self:get_template_child(MoonZaphire.ChatView, 'scroll_box')
	self.priv.message_box = self:get_template_child(MoonZaphire.ChatView, 'message_box')
	local message_scroll = self:get_template_child(MoonZaphire.ChatView, 'message_scroll')
	local buffer_message = self:get_template_child(MoonZaphire.ChatView, 'buffer_message')
	local message_text = self:get_template_child(MoonZaphire.ChatView, 'message_text')
	local btn_send = self:get_template_child(MoonZaphire.ChatView, 'btn_send')

	self.priv.scroll_box.id = 'scroll_box'
	self.priv.message_box.id = 'message_box'

	--- By clicking I search a chat list
	btn_search.on_toggled = function (self)
		if  (self.active) then
			MoonZaphire.ChatList:show_search(true)
		else
			MoonZaphire.ChatList:show_search(false)
		end
	end

	--- By pressing the button I show the chat details
	switch_details.on_toggled = function (self)
		chat_details:set_reveal_child(self.active)
	end

	--- By losing the focus I eliminate the placeholder
	message_text.on_focus_in_event = function (self, event)
		if (buffer_message:get_text(buffer_message:get_start_iter(),
			buffer_message:get_end_iter(), true) == placeholder_str)
		then
			buffer_message.text = ''
		end
		utils:removeClass(self, 'placeholder')
	end

	--- By having the focus I add the placeholder
	placeholder_str = 'Write a message...'
	message_text.on_focus_out_event = function (self, event)
		if (buffer_message:get_text(buffer_message:get_start_iter(),
			buffer_message:get_end_iter(), true) == '')
		then
			buffer_message.text = placeholder_str
		end
		utils:addClass(self, 'placeholder')
	end


	--- Send a message.
	local send_message = function ()
		local current_chat = chat:get_visible_child_name()
		local timeago = os.date('%H:%M')
		if (buffer_message.text ~= '') then
			--MoonZaphire.ChatView:new_message {
				--type = 'to',
				--message = buffer_message.text,
				--time = timeago
			--}
			mzmqtt:composer(buffer_message.text)
			mzmqtt:send(current_chat)
			buffer_message.text = ''
		else
			return false
		end
		message_text:grab_focus()
		return true
	end

	--- When sending a message by pressing the ENTER key
	message_text.on_key_press_event = function (self, event)
		local shift_on = event.state.SHIFT_MASK

		if (event.keyval == Gdk.KEY_Return and not shift_on) then
			send_message()
		else
			return false
		end
		return true
	end

	self.priv.message_box.on_size_allocate = function ()
		MoonZaphire.ChatView:scroll_down()
	end

	--- By pressing the button you sent the message
	btn_send.on_clicked = function (self)
		send_message()
		return true
	end
end

--- This method creates a new message.
-- @param t table: A table with the content of the message (author's name,
-- type of message, the message and the date sent).
-- @return true or false and an error message.
-- @usage:
-- MoonZaphire.ChatView:new_message({
--     id = 'message-1',
--     type = "from", -- or "to".
--     from = '/chat/user/johndoe/'
--     author = "Johndoe", -- if "type" is "to" this property is not required.
--     message = "Hi I'm johndoe",
--     time = os.time()
-- })
function MoonZaphire.ChatView:new_message(t)
	local t, message, message_box = t or {}

	if not t.type then
		return false, 'Define a message type'
	end

	local current_time = os.date("%H:%M:%S", t.time)
	-- local current_time = os.date("*t", t.time)
	-- {year = 1998, month = 9, day = 16, yday = 259, wday = 4,
    -- hour = 23, min = 48, sec = 10, isdst = false}

	if t.type == 'to' then
		message = MoonZaphire.MessageTo {
			id = t.id
		}
		message.priv.message.label = t.message
		message.priv.time.label = current_time

		scroll_down = true
		message_box = chat:get_visible_child().child.message_box
	elseif t.type == 'from' then
		if not t.author then
			return false, '"author" property is required'
		end
		if not t.from then
			return false, '"from" property is required'
		end
		message = MoonZaphire.MessageFrom {
			id = t.id
		}
		message.priv.author.label = t.author
		message.priv.message.label = t.message
		message.priv.time.label = current_time

		message_box = chat:get_child_by_name(t.from).child.message_box
	else
		return false, 'The message type is not valid'
	end

	message_box:add(message)
	return true
end

--- This method scrolls the chat down.
function MoonZaphire.ChatView:scroll_down()
	if scroll_down then
		local scroll_box = chat:get_visible_child().child.scroll_box
		local adj = scroll_box:get_vadjustment()
		adj:set_value(adj.upper - adj.page_size)
		scroll_down = false
	end
end

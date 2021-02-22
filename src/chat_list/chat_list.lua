--[[--
 @package   MoonZaphire
 @filename  chat_list/chat_list.lua
 @version   1.0
 @author    Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date      05.02.2021 07:24:46 -04
]]

--- I create the ChatList subclass of MoonZaphire
MoonZaphire:class('ChatList', Gtk.Box)

local items, search_box, search

--- At the beginning of the class
function MoonZaphire.ChatList:_class_init(klass)
	--- I load the template
	klass:set_template_from_resource(
		'/com/github/diazvictor/MoonZaphire/data/ui/chat_list/chat_list.ui'
	)
	--- I add the desired elements to the template
	klass:bind_template_child_full('items', true, 0)
	klass:bind_template_child_full('search_box', true, 0)
	klass:bind_template_child_full('search', true, 0)
end

--- When building the class
function MoonZaphire.ChatList:_init()
	-- Start template
	self:init_template()

	-- I load the template objects
	items = self:get_template_child(MoonZaphire.ChatList, 'items')
	search_box = self:get_template_child(MoonZaphire.ChatList, 'search_box')
	search = self:get_template_child(MoonZaphire.ChatList, 'search')

	local i = 0
	search.on_key_release_event = function (self, env)
		if ( env.keyval  == Gdk.KEY_Return ) then
			if (self.text ~= '') then
				i = i + 1
				local id_member = tostring(i)
				local member = MoonZaphire.ChatList:new_chat({
					id = id_member,
					chatname = 'Johndoe #' .. i
				})
			end
		end
	end
end

function MoonZaphire.ChatList:get()
	return items
end

--- I show the search bar and set the focus on it
-- @param state boolean: true show, false hide
-- @return true or false
function MoonZaphire.ChatList:show_search(state)
	local str = type(state)
	local message = ('A boolean was expected and %s was passed.'):format(str)
	if type(state) == 'boolean' then
		search_box:set_reveal_child(state)
		if state == true then
			search:grab_focus()
		end
		search.text = ''
		return true
	end
	utils:show_log('SEARCH', 'warning', message)
	return false
end


--- Creates a new chat
-- @param t table: this table contains the values of the chat (such as, name
-- and id).
-- @return the widget or false and an error message.
-- @usage:
-- local member = MoonZaphire.ChatList:new_chat({
--     id = 1,
--     chatname = 'Johndoe'
-- })
function MoonZaphire.ChatList:new_chat(t)
	local t = t or {}

	if not t.id then
		return false, 'Chat id is required'
	end

	if not t.chatname then
		return false, 'Chat name is required'
	end

	local member = MoonZaphire.ChatListItem {
		id = t.id
	}
	member.priv.chatname.label = t.chatname

	items:add(member)
	return member
end

--- Update a chat
-- @param t table: this table contains the values of the chat (
-- such as the name, the last message, the time of the message and
-- the number of unread messages).
-- @return t or false and an error message.
-- @usage:
-- MoonZaphire.ChatList:update_chat({
--     id = member.id,
--     chatname = 'Janedoe',
--     message_number = 1,
--     last_message = 'Hi I'm janedoe',
--     time = os.date('%H:%M')
-- })
function MoonZaphire.ChatList:update_chat(t)
	local t, state = t or {}
	local member = items.child[t.id]

	state = (t.chatname ~= nil)
	if (state) then
		member.priv.chatname.label = t.chatname
	end

	state = (t.message_number ~= nil)
	if (state) then
		member.priv.box_message_number.visible = true
		member.priv.message_number.label = tostring(t.message_number)
	end

	state = (t.time ~= nil)
	if (not state) then
		return false, 'time is required'
	end

	state = (t.last_message ~= nil)
	if (not state) then
		return false, 'the last_mensage is required'
	end

	member.priv.last_message.label = t.last_message
	member.priv.time.visible = true
	member.priv.time.label = t.time

	return t
end

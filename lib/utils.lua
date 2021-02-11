--[[--
 @package   SODplayer
 @filename  utils.lua
 @version   1.5
 @author    Diaz Urbaneja Victor Diego Alejandro <sodomon2@gmail.com>
 @date      01.08.2020 19:22:11 -04
--]]

local utils = {}

function utils:split(str,sep)
    local sep, fields = sep or ":", {}
    local pattern = string.format("([^%s]+)", sep)
    str:gsub(pattern, function(c) fields[#fields+1] = c end)
    return fields
end

function utils:isfile(file)
	return (io.open(tostring(file), "r") ~= nil)
end

function utils:path_name(uri)
    local uri   = uri or ''
    local _turi =  utils:split(uri,'/')
    local _name = _turi[#_turi]
    local _path = '/' .. table.concat(_turi, '/')
    table.remove(_turi,(#_turi))
    result =  { name = _name, path = _path }
    return result
end

-- @author Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
-- Example to string:Lorem ipsum dolor sit...
function utils:truncate(str, letter)
	local t,s = {}, str
	if #str > letter then
		for w in string.gmatch(str, ".") do
			table.insert(t, w)
			if #t > letter then
				break
			end
		end
		s = ('%s...'):format(table.concat(t))
		return s
	else
		return s
	end
end

--- Remueve espacios iniciales y finales de una cadena
--- @param value el texto a limpiar
--- @return el texto limpiado
function utils:trim(value)
	return (string.gsub(value, "%s+$", ""):gsub("^%s+", ""))
end

function utils:addClass(widget, classname)
	if (not widget) then
		return false
	end
	local element = widget:get_style_context()
    element:add_class(classname)
    return true
end

function utils:hasClass(widget, classname)
	if (not widget) then
		return false
	end
	local element = widget:get_style_context()
    if element:has_class(classname) then
		return true
	else
		return false
	end
end

function utils:removeClass(widget, classname)
	if (not widget) then
		return false
	end
	local element = widget:get_style_context()
    element:remove_class(classname)
    return true
end

--- Muestro una alerta
-- @param t table: Información para mostrar
-- @return true or false
-- @example:
--	utils:show_alert({
-- 		title = 'Title',
-- 		subtitle = 'Subtitle',
-- 		message = 'Message',
--		show_close = true,	-- show close button. timeout must not be set.
--		timeout = 5 		-- wait 5 seconds before closing the alert. show_close must be false
-- 	})
function utils:show_alert(t)
	-- @TODO: esto puede mejorar
	local t, title, subtitle, button_close = t or {}, Gtk.Label {
		visible = false,
	}, Gtk.Label {
		visible = false,
	}, Gtk.Box {
		visible = false,
	}
	if not t.message then
		return false, 'Message is required'
	end
	if t.title then
		title = Gtk.Label {
			visible = true,
			id = 'alert_title',
			label = t.title
		}
	end
	if t.subtitle then
		subtitle = Gtk.Label {
			visible = true,
			id = 'alert_subtitle',
			label = t.subtitle
		}
	end
	if (t.show_close and not t.timeout) then
		button_close = Gtk.Box {
			visible = true,
			expand = false,
			halign = Gtk.Align.END,
			margin_top = 10,
			margin_right = 10,
			Gtk.Button {
				visible = true,
				id = 'btn_quit',
				expand = true,
				relief = Gtk.ReliefStyle.NONE,
				Gtk.Image {
					visible = true,
					icon_name = 'window-close-symbolic'
				},
				on_clicked = function()
					background.child.alert_box:destroy()
				end
			}
		}
	end
	background:add_overlay (
		Gtk.Box {
			visible = true,
			id = 'alert_box',
			orientation = Gtk.Orientation.VERTICAL,
			button_close,
			Gtk.Box {
				visible = true,
				spacing = 10,
				orientation = Gtk.Orientation.VERTICAL,
				expand = true,
				halign = Gtk.Align.CENTER,
				valign = Gtk.Align.CENTER,
				title,
				subtitle,
				Gtk.Label {
					visible = true,
					id = 'alert_message',
					halign = Gtk.Align.CENTER,
					use_markup = true,
					wrap = true,
					lines = 1,
					selectable = true,
					label = t.message
				}
			}
		}
	)
	utils:addClass(background.child.alert_box, 'alert-dialog')
	if t.title then
		utils:addClass(background.child.alert_title, 'alert-title')
	end
	if t.subtitle then
		utils:addClass(background.child.alert_subtitle, 'alert-subtitle')
	end
	if (t.timeout and not t.show_close) then
		GLib.timeout_add_seconds(
			GLib.PRIORITY_DEFAULT, t.timeout,
			function()
				background.child.alert_box:destroy()
				return false
			end
		)
	end
	return true
end

--- I display a log message
-- @param name string: The identifier
-- @param type string: the types are shown below
-- `message`
-- `warning`
-- `critical`
-- `error`
-- `debug`
-- @param message string: The message
function utils:show_log(name, type, message)
	lgi.log.domain(name)[type](message)
end

return utils

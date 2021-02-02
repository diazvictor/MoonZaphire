--[[--
 @package   SODplayer
 @filename  utils.lua
 @version   1.5
 @author    Diaz Urbaneja Victor Diego Alejandro <sodomon2@gmail.com>
 @date      01.08.2020 19:22:11 -04
--]]

local utils = class('utils')

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

return utils
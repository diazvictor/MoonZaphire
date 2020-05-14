function setLang(f)
    ok, err = pcall(require, "languages." .. f)
    if not ok then
        print("The language required ('" .. f .. "') had an error, the program will still continue.")
        print("The error was: " .. err)
        currentLang = {objt = {}}
        return 1
    else
        currentLang = require("languages." .. f) 
        print("The language required ('" .. f .. "') successfully loaded!")
        return 0
    end
    return "wtf"
end

function getLINE(msg, inputs) --the inputs arg is a workaround, dont hate me
    if not type(currentLang[msg])=="string" then 
        print("The line '" .. msg .. "' doesn't exists.")
        return "PLACEHOLDER_"
    end
    local msg = currentLang[msg]
    for k, v in ipairs(inputs or {}) do
        msg = msg:gsub("$" .. k, v)
    end
    return msg
end

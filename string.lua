---Split the string `s` at each occurrence of `pattern`, starting from `init`.
---@param s string
---@param pattern string
---@param init integer
---@param plain boolean when true, pattern matching facilities are turned off.
---@return function stateful an iterator of each substring
function string.gsplit(s, pattern, init, plain)
    init = init or 1
    local done = false
    return function()
        if done then
            return
        end
        local firstindex, lastindex = s:find(pattern, init, plain)
        local result = s:sub(init, (firstindex or 0) - 1)
        init = lastindex and lastindex + 1
        done = not firstindex
        return result
    end
end

---Pads the start of a string with a character.
---@param s string
---@param len integer
---@param pad string
function string.lpad(s, len, pad)
    return string.rep(pad or " ", len - s:len()) .. s
end

---Removes any leading characters from `s` which match the pattern.
---@param s string
---@param pattern string defaults to `"%s"`, matching whitespace
function string.lstrip(s, pattern)
    return s:gsub("^" .. (pattern or "%s") .. "+", "")
end

---Pads the end of a string with a character.
---@param s string
---@param len integer
---@param pad string
function string.rpad(s, len, pad)
    return s .. string.rep(pad or " ", len - s:len())
end

---Removes any trailing characters from `s` which match the pattern.
---@param s string
---@param pattern string defaults to `"%s"`, matching whitespace
function string.rstrip(s, pattern)
    return s:gsub((pattern or "%s") .. "+$", "")
end

---Split the string `s` at each occurrence of `pattern`, starting from `init`.
---@param s string
---@param pattern string
---@param init integer
---@param plain boolean when true, pattern matching facilities are turned off.
---@return table strings a list of each substring
function string.split(s, pattern, init, plain)
    local result = {}
    for value in string.gsplit(s, pattern, init, plain) do
        table.insert(result, value)
    end
    return result
end

---Strip any occurrences of `pattern` from the start and end of `s`.
---@param s string
---@param pattern string defaults to matching whitespace
function string.strip(s, pattern)
    pattern = pattern or "%s"
    return s:lstrip(pattern):rstrip(pattern)
end

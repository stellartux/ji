---Remove a single trailing newline from a string.
---@param s string
function string.chomp(s)
    return s:gsub("\r?\n$", "")
end

---Finds the substring which matches `pattern`, if it occurs at the end of `s`.
---Also has a partially applied form with the signature
---`endswith(pattern[, plain]) -> (s) -> string`
---@param s string
---@param pattern string|boolean
---@param plain boolean defaults to `false`
---@return string|function
function string.endswith(s, pattern, plain)
    if not pattern or pattern == true then
        return function(ss)
            return string.endswith(ss, s, pattern)
        end
    elseif plain then
        if string.sub(s, -#pattern) == pattern then
            return pattern
        end
    else
        if string.sub(pattern, -1) ~= "$" then
            pattern = pattern .. "$"
        end
        return string.match(s, pattern)
    end
end

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

---Test whether all the characters of `s` are in the ASCII range.
---@param s string
function string.isascii(s)
    for i = 1, #s do
        if string.byte(s, i) >= 128 then
            return false
        end
    end
    return true
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

---Finds the substring which matches `pattern`, if it occurs at the start of `s`.
---Also has a partially applied form with the signature
---`startswith(pattern, plain) -> (s) -> string`
---@param s string
---@param pattern string|boolean
---@param plain boolean
---@return string|function
function string.startswith(s, pattern, plain)
    if not pattern or pattern == true then
        return function(ss)
            return string.startswith(ss, s, pattern)
        end
    elseif plain then
        if string.sub(s, 1, #pattern) == pattern then
            return pattern
        end
    else
        if string.sub(pattern, 1) ~= "^" then
            pattern = "^" .. pattern
        end
        return string.match(s, pattern)
    end
end

---Strip any occurrences of `pattern` from the start and end of `s`.
---@param s string
---@param pattern string defaults to matching whitespace
function string.strip(s, pattern)
    pattern = pattern or "%s"
    return s:lstrip(pattern):rstrip(pattern)
end

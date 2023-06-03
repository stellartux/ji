local String = require("ji/module")("String")

---Remove a single trailing newline from a string.
---@param s string
function String.chomp(s)
    return (s:gsub("\r?\n$", ""))
end

---Iterate over each byte in a string.
---@param s string
---@param start integer? defaults to `1`
---@param stop integer? defaults to `#s`
function String.eachbyte(s, start, stop)
    start = start or 1
    stop = stop or #s
    ---@return nil
    ---@overload fun(_, i: integer): integer, integer
    return function(_, i)
        if i + 1 <= stop then
            return i + 1, s:byte(i + 1)
        end
    end, nil, start - 1
end

--- Iterate over each character string in a string.
---@param s string
---@param start integer? defaults to `1`
---@param stop integer? defaults to `#s`
---@return fun(_, i: integer): (integer?, string?), nil, integer
function String.eachchar(s, start, stop)
    start = start or 1
    stop = stop or #s
    return function(_, i)
        i = i + 1
        if i <= stop then
            return i, s:sub(i, i)
        end
    end, nil, start - 1
end

--- Finds the substring which matches `pattern`, if it occurs at the end of `s`.
---@param s string
---@param pattern string
---@param plain boolean? defaults to `false`
---@return string?
---@overload fun(pattern: string, plain?: boolean): fun(s: string): string?
function String.endswith(s, pattern, plain)
    if not pattern or pattern == true then
        return function(ss)
            return String.endswith(ss, s, pattern)
        end
    elseif plain then
        if s:sub(- #pattern) == pattern then
            return pattern
        end
    else
        if pattern:byte(-1) ~= 36 then
            pattern = pattern .. "$"
        end
        return s:match(pattern)
    end
end

---Split the string `s` at each occurrence of `pattern`, starting from `init`.
---@param s string
---@param pattern string
---@param init integer? defaults to `1`.
---@param plain boolean? defaults to `false`, when `true`, pattern matching facilities are turned off.
---@return fun(): string?
function String.gsplit(s, pattern, init, plain)
    if type(init) == "boolean" then plain = init end
    init = math.tointeger(init) or 1
    return function()
        if init > #s then return end
        local result
        result, init = String.split(s, pattern, init, plain)
        return result or s:sub(init, #s)
    end
end

---Test whether all the characters of `s` are in the ASCII range.
---@param s string
function String.isascii(s)
    for i = 1, #s do
        if s:byte(i) >= 128 then
            return false
        end
    end
    return true
end

---Pads the start of a string with a character.
---@param s string
---@param len integer
---@param pad string? defaults to a single space character.
function String.lpad(s, len, pad)
    return string.rep(pad and pad:sub(1, 1) or " ", len - #s) .. s
end

---Removes any leading characters from `s` which match the pattern.
---@param s string
---@param pattern string? defaults to `"%s"`, matching whitespace
function String.lstrip(s, pattern)
    return s:gsub("^" .. (pattern or "%s") .. "+", "")
end

---Pads the end of a string with a character.
---@param s string
---@param len integer
---@param pad string? defaults to a single space character.
function String.rpad(s, len, pad)
    return s .. string.rep(pad and string.sub(pad, 1, 1) or " ", len - s:len())
end

---Removes any trailing characters from `s` which match the pattern.
---@param s string
---@param pattern string? defaults to `"%s"`, matching whitespace
function String.rstrip(s, pattern)
    return s:gsub((pattern or "%s") .. "+$", "")
end

--- Split the string `s`, returning the substring starting at `init`, up to the
--- the first match, and the index of the first byte after the match.
--- Returns `nil` if no match is found.
---@param s string
---@param pattern string
---@param init integer? defaults to 1
---@param plain boolean? when true, pattern matching facilities are turned off.
---@return string substring, integer nextinit
---@overload fun(s: string, pattern: string, init?: integer, plain?: boolean): nil
function String.split(s, pattern, init, plain)
    if type(init) == "boolean" then
        plain, init = init, 1
    else
        init = math.tointeger(init) or 1
    end
    local firstindex, lastindex = s:find(pattern, init, plain)
    if firstindex then
        return s:sub(init, firstindex - 1), lastindex + 1
    elseif init <= #s then
        return s:sub(init), #s + 1
    end
end

---Finds the substring which matches `pattern`, if it occurs at the start of `s`.
---@param s string
---@param pattern string
---@param plain boolean? defaults to `false`
---@return string?
---@overload fun(pattern: string, plain?: boolean): fun(s: string): string?
function String.startswith(s, pattern, plain)
    if not pattern or pattern == true then
        return function(ss)
            return String.startswith(ss, s, pattern)
        end
    elseif plain then
        if s:sub(1, #pattern) == pattern then
            return pattern
        end
    else
        if s:byte() ~= 94 then
            pattern = "^" .. pattern
        end
        return s:match(pattern)
    end
end

---Strip any occurrences of `pattern` from the start and end of `s`.
---@param s string
---@param pattern string? defaults to matching whitespace
function String.strip(s, pattern)
    pattern = pattern or "%s"
    return String.rstrip(String.lstrip(s, pattern), pattern)
end

return String

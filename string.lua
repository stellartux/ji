local String = require("ji/module")()
local Iterators = require("ji/iterators")

---Remove a single trailing newline from a string.
---@param s string
function String.chomp(s)
    return s:gsub("\r?\n$", "")
end

---Iterate over each byte in a string.
---@param s string
---@param start integer? defaults to `1`
---@param stop integer? defaults to `#s`
---@return function iterator, ... yields integers
function String.eachbyte(s, start, stop)
    start = start or 1
    stop = stop or #s
    return function(_, i)
        if i + 1 <= stop then
            return i + 1, string.byte(s, i + 1)
        end
    end, nil, start - 1
end

---Iterate over each character string in a string.
---@param s string
---@param start integer? defaults to `1`
---@param stop integer? defaults to `#s`
---@return function iterator, ... yields strings
function String.eachchar(s, start, stop)
    start = start or 1
    stop = stop or #s
    return function(_, i)
        if i + 1 <= stop then
            return i + 1, string.sub(s, i + 1, i + 1)
        end
    end, nil, start - 1
end

---Finds the substring which matches `pattern`, if it occurs at the end of `s`.
---Also has a partially applied form with the signature
---`endswith(pattern[, plain]) -> (s) -> string`
---@param s string
---@param pattern string|boolean
---@param plain boolean? defaults to `false`
---@return string|function?
function String.endswith(s, pattern, plain)
    if not pattern or pattern == true then
        return function(ss)
            return String.endswith(ss, s, pattern)
        end
    elseif plain then
        if string.sub(s, - #pattern) == pattern then
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
---@param init integer? defaults to `1`.
---@param plain boolean? defaults to `nil`, when `true`, pattern matching facilities are turned off.
---@return function stateful an iterator of each substring
function String.gsplit(s, pattern, init, plain)
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
function String.isascii(s)
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
---@param pad string? defaults to a single space character.
function String.lpad(s, len, pad)
    return string.rep(pad and string.sub(pad, 1, 1) or " ", len - s:len()) .. s
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

---Split the string `s` at each occurrence of `pattern`, starting from `init`.
---@param s string
---@param pattern string
---@param init integer
---@param plain boolean when true, pattern matching facilities are turned off.
---@return table strings a list of each substring
function String.split(s, pattern, init, plain)
    return Iterators.collect(String.gsplit(s, pattern, init, plain))
end

---Finds the substring which matches `pattern`, if it occurs at the start of `s`.
---Also has a partially applied form with the signature
---`startswith(pattern, plain) -> (s) -> string`
---@param s string
---@param pattern string|boolean
---@param plain boolean? defaults to `false`
---@return string|function?
function String.startswith(s, pattern, plain)
    if not pattern or pattern == true then
        return function(ss)
            return String.startswith(ss, s, pattern)
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
---@param pattern string? defaults to matching whitespace
function String.strip(s, pattern)
    pattern = pattern or "%s"
    return String.rstrip(String.lstrip(s, pattern), pattern)
end

return String

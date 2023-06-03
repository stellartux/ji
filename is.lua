--- The `is` module contains predicates.
local is = require("ji/module")("is")
local String = require("ji/string")

---@param x string|number
---@return boolean?
function is.alnum(x)
    if type(x) == "string" then
        return not not x:match("^%w+$")
    elseif type(x) == "number" then
        return x >= 97 and x <= 122
            or x >= 65 and x <= 90
            or x >= 48 and x <= 57
    end
end

---@param x string|number
---@return boolean?
function is.alpha(x)
    if type(x) == "string" then
        return not not x:match("^%a+$")
    elseif type(x) == "number" then
        return x >= 97 and x <= 122 or x >= 65 and x <= 90
    end
end

---@param x string|number
---@return boolean?
function is.ascii(x)
    if type(x) == "string" then
        return String.isascii(x)
    elseif type(x) == "number" then
        return x >= 0 and x <= 127
    end
end

---@param x string|number
---@return boolean?
function is.blank(x)
    if type(x) == "string" then
        return not not x:match("^[\t ]+$")
    elseif type(x) == "number" then
        return x == 9 or x == 32
    end
end

---@param x string|number
---@return boolean?
function is.cntrl(x)
    if type(x) == "string" then
        return not not x:match("^%c+$")
    elseif type(x) == "number" then
        return x >= 0 and x <= 31 or x == 127
    end
end

---@param x string|number
---@return boolean?
function is.digit(x)
    if type(x) == "string" then
        return not not x:match("^%d+$")
    elseif type(x) == "number" then
        return x >= 48 and x <= 57
    end
end

function is.empty(x)
    return #x == 0
end

---@return fun(y): boolean -- x == y
function is.equal(x)
    return function(y) return y == x end
end

---@param x number
function is.even(x)
    return x % 2 == 0
end

function is.falsey(x)
    return not x
end

---@param x string|number
---@return boolean?
function is.graph(x)
    if type(x) == "string" then
        return not not x:match("^%g+$")
    elseif type(x) == "number" then
        return x >= 33 and x <= 126
    end
end

---@return function `y -> y <= x`
function is.lessequal(x)
    return function(y) return y <= x end
end

---@return function `y -> y < x`
function is.lessthan(x)
    return function(y) return y < x end
end

---@param x string|number
---@return boolean?
function is.lower(x)
    if type(x) == "string" then
        return not not x:match("^%l+$")
    elseif type(x) == "number" then
        return x >= 97 and x <= 122
    end
end

---@return fun(y): boolean -- y >= x
function is.greaterequal(x)
    return function(y) return y >= x end
end

---@return fun(y): boolean -- y > x
function is.greaterthan(x)
    return function(y) return y > x end
end

function is.nothing(x)
    return x == nil
end

function is.odd(x)
    return x % 2 == 1
end

function is.one(x)
    return x == 1
end

---@param x string|number
---@return boolean?
function is.print(x)
    if type(x) == "string" then
        return not not x:match("^[%g%s]+$")
    elseif type(x) == "number" then
        return x >= 32 and x <= 126
    end
end

---@param x string|number
---@return boolean?
function is.punct(x)
    if type(x) == "string" then
        return not not x:match("^%p+$")
    elseif type(x) == "number" then
        return x >= 33 and x <= 47
            or x >= 58 and x <= 64
            or x >= 91 and x <= 96
            or x >= 123 and x <= 126
    end
end

---@param x string|number
---@return boolean?
function is.space(x)
    if type(x) == "string" then
        return x:match("^%s+$")
    elseif type(x) == "number" then
        return x == 32 or x == 10 or x == 13 or x == 9
    end
end

function is.truthy(x)
    return not not x
end

---@param x string|number
---@return boolean?
function is.upper(x)
    if type(x) == "string" then
        return not not x:match("^%u+$")
    elseif type(x) == "number" then
        return x >= 65 and x <= 90
    end
end

---@param x string|number
---@return boolean?
function is.xdigit(x)
    if type(x) == "string" then
        return not not x:match("^%x+$")
    elseif type(x) == "number" then
        return x >= 48 and x <= 57
            or x >= 65 and x <= 70
            or x >= 97 and x <= 102
    end
end

function is.zero(x)
    return x == 0
end

return is

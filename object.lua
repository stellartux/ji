---@class Object
---An object is a table which can have modification prevented in different ways.
---
--- - By default, any key-value pair can be added to, changed on or removed from
---   an object.
--- - `Object.preventextensions` prevents new keys from being added to the object.
--- - `Object.seal` prevents extensions and prevents keys from being removed from
---    the object.
--- - `Object.freeze` seals the object and prevents an value from being changed on
---    the object.
---
---A `shoulderror` boolean can be passed to any of the methods. If `shoulderror` is
---true, the method will throw an error when a disallowed change is attempted. An
---object can have its status increased but not decreased, i.e. a sealed object may
---go on to be frozen, but a frozen object can't be unfrozen and revert to being
---sealed. `shoulderror` can be changed.
local Object = require("class")()
Object.mt = {}

function Object:new(data)
    local object = {
        data = type(data) == "table" and data or {},
        shoulderror = false,
        status = 0, -- 0 = extensible, 1 = non-extensible, 3 = sealed, 7 = frozen
    }
    setmetatable(object, self.mt)
    return object
end

---Freeze an object, sealing the object and preventing any value from being changed.
---@param object Object
---@param shoulderror boolean throw an error on attempts to mutate a field
---@return Object object
function Object.freeze(object, shoulderror)
    rawset(object, "shoulderror", shoulderror and true or false)
    rawset(object, "status", 7)
    return object
end

---Check whether new keys can be added to the object.
---@param object Object
---@return boolean extensible when `true`, keys can be added to the object.
function Object.isextensible(object)
    return rawget(object, "status") & 1 == 0
end

---Check whether new keys can be added to the object.
---@param object Object
---@return boolean frozen when `true`, values can't be changed on the object.
function Object.isfrozen(object)
    return rawget(object, "status") & 4 == 4
end

---Check whether keys can be removed from the object.
---@param object Object
---@return boolean sealed when `true`, keys can't be removed from the object.
function Object.issealed(object)
    return rawget(object, "status") & 2 == 2
end

---Prevent extensions of an object, so that new keys can't be added.
---@param object Object
---@param shoulderror boolean throw an error on attempts to add a new key.
---@return Object object
function Object.preventextensions(object, shoulderror)
    rawset(object, "shoulderror", shoulderror and true or false)
    if rawget(object, "status") < 1 then
        rawset(object, "status", 1)
    end
end

---Seal an object, preventing any keys from being added or removed.
---@param object Object
---@param shoulderror boolean throw an error on attempts to add or remove a key.
---@return Object object
function Object.seal(object, shoulderror)
    rawset(object, "shoulderror", shoulderror and true or false)
    if rawget(object, "status") < 3 then
        rawset(object, "status", 3)
    end
end

function Object.mt:__index(key)
    return rawget(self, "data")[key]
end

function Object.mt:__len()
    return #rawget(self, "data")
end

Object.__name = "Object"

function Object.mt:__newindex(key, value)
    local status = rawget(self, "status")
    local haskey = rawget(self, "data")[key] ~= nil
    local shoulderror = rawget(self, "shoulderror")
    if status & 1 == 1 and not haskey then
        if shoulderror then
            error("Non-extensible object can't be extended.'")
        end
    elseif status & 2 == 2 and value == nil then
        if shoulderror then
            error("Sealed object can't have key removed.")
        end
    elseif status & 4 == 4 then
        if shoulderror then
            error("Frozen object can't be modified.")
        end
    else
        rawget(self, "data")[key] = value
    end
end

function Object.mt:__pairs()
    return pairs(rawget(self, "data"))
end

return Object

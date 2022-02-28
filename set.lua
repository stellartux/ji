---@class Set
local Set = require("class")({ data = {}, length = 0 })

---Create a new set from the values of the given table, or an empty set if no
---table is given.
---@param init table
---@return Set new
function Set:new(init)
    local set = { data = {}, length = 0 }
    for _, value in pairs(init or {}) do
        if not set.data[value] then
            set.data[value] = true
            set.length = set.length + 1
        end
    end
    setmetatable(set, self)
    return set
end

---Adds a value to the set.
---@return Set self
function Set:add(value)
    if not self:contains(value) then
        self.data[value] = true
        self.length = self.length + 1
    end
    return self
end

---Check if the set contains the given value.
function Set:contains(value)
    return self.data[value] == true
end

---Make a shallow copy of the set.
---@return Set copy
function Set:copy()
    local set = { data = {}, length = self.length }
    for key, value in pairs(self.data) do
        set.data[key] = value
    end
    setmetatable(set, getmetatable(self))
    return set
end

---Delete the value from the set.
---@param value any
---@return Set self
function Set:delete(value)
    if self:contains(value) then
        self.data[value] = nil
        self.length = self.length - 1
    end
    return self
end

---Make a set with all the values that are in the set but not in the other set.
---@param other Set
---@return Set new
function Set:difference(other)
    local difference = self:copy()
    for value in pairs(other) do
        difference:delete(value)
    end
    return difference
end

---Remove all values from the set.
---@return Set self
function Set:empty()
    self.data = {}
    self.length = 0
    return self
end

---Make a set with the values which are in both the set and the other set.
---@param other Set
---@return Set new
function Set:intersect(other)
    local intersection = Set:new{}
    for value in pairs(self) do
        if other:contains(value) then
            intersection:add(value)
        end
    end
    return intersection
end

---Check whether intersection of the sets is empty.
---@param other Set
function Set:isdisjoint(other)
    for value in pairs(self) do
        if not other:contains(value) then
            return false
        end
    end
    return true
end

---Check whether the set is empty.
function Set:isempty()
    return self.length == 0
end

---Check whether the set is a subset of the other set.
---@param other Set
function Set:issubset(other)
    for value in pairs(self) do
        if not other:contains(value) then
            return false
        end
    end
    return true
end

---List each value in the set.
---@return table
function Set:list()
    local list = {}
    for value in pairs(self) do
        list[#list + 1] = value
    end
    return list
end

---Adds each value of the other set to the set.
---@param other Set
---@return Set self
function Set:merge(other)
    for value in pairs(other) do
        self:add(value)
    end
    return self
end

---Make a copy of the set with the value removed.
---@param value any
---@return Set new
function Set:remove(value)
    return self:copy():delete(value)
end

---Create the union of the set and another set.
---@param other Set
---@return Set new
function Set:union(other)
    return self:copy():merge(other)
end

---@param other Set
function Set:__eq(other)
    if #self ~= #other then
        return false
    end
    for value in pairs(self) do
        if not other:contains(value) then
            return false
        end
    end
    return true
end

---@return integer
function Set:__len()
    return self.length
end

Set.__name = "Set"

local function setpairsnext(data, key)
    key = next(data, key)
    return key, key
end

function Set:__pairs()
    return setpairsnext, self.data
end

---@return string
function Set:__tostring()
    if #self < 32 then
        return self.__name .. "{" .. table.concat(self:list(), ", ") .. "}"
    else
        return self.__name .. " with " .. #self .. " items"
    end
end

return Set

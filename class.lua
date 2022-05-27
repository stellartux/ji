---@class Class
local Class = {}
setmetatable(Class, Class)

---Create a Class from the given table.
---@param name string? the name of the class
---@return Class
function Class:new(name)
    local class = {}
    setmetatable(class, self)
    class.__index = class
    class.__name = name
    return class
end

function Class.__call(self, ...)
    return self:new(...)
end

Class.__name = "Class"

function Class:__tostring()
    return self.__name or self ~= getmetatable(self) and
        getmetatable(self).__name or "table"
end

return Class

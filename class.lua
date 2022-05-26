---@class Class
local Class = {}
setmetatable(Class, Class)

---Create a Class from the given table.
---@param class table? the prototype table
---@return Class
function Class:new(class)
    class = class or {}
    setmetatable(class, self)
    class.__index = self
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

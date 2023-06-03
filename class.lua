---@class Class
---@field close function?
---
--- The `Class` class allows for quick creation of classes. These are typically
--- created one per file, like so:
---
---     ---@class MyClass
---     local MyClass = require("ji/class")("MyClass")
---
---     function MyClass:new(...)
---         local instance = {}
---         -- validate any arguments and construct the instance from them
---         return instance
---     end
---
---     return MyClass
---
--- To initialise your class:
---
---     local MyClass = require("myclass")
---     local instance = MyClass()
---
local Class = { __name = "Class" }

---Create a Class from the given table.
---@param name string? the name of the class
---@param class table? table to make into a class, defaults to {}
---@return Class class
function Class:new(name, class)
    if type(name) == "table" then
        name, class = name.__name, name
    end
    assert(name == nil or type(name) == "string",
        ("bad argument #1 to 'Class' (string/table expected, got %s)")
        :format(type(name)))
    assert(class == nil or type(class) == "table",
        ("bad argument #2 to 'Class' (table expected, got %s)")
        :format(type(name)))
    class = class or {}
    class.__name = name
    class.__index = class
    return class
end

function Class.__call(self, ...)
    return setmetatable(self:new(...), self)
end

--- The `repr` function should be implemented by classes to print a detailed
--- representation of the object, ideally in a way that can be deserialised
--- back to a copy of the original object.
---@return string
function Class:repr()
    return tostring(self) or tostring(getmetatable(self))
end

--- The `show` function is a more detailed version of `print`, and falls back
--- to `print` if `show` is unimplemented. Typically, classes don't implement
--- `show` directly, but implement `repr` which is used by `show`, but it can
--- be useful to implement the `show` function in a way that doesn't create
--- as many temporary strings, if the object will be shown often.
function Class:show()
    print(self:repr())
end

function Class:__close()
    if type(self.close) == "function"
        or getmetatable(self.close) and getmetatable(self.close).__call then
        self:close()
    end
end

return setmetatable(Class, Class)

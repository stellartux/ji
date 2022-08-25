---@class Module
---Module utility functions.
local Module = {}
setmetatable(Module, Module)
local mt = { __index = Module }

---Create a new module.
---@param init table
---@return Module
function Module:new(init)
    local module = type(init) == "table" and init or {}
    if type(init) == "string" then
        module.__name = init
    end
    setmetatable(module, mt)
    return module
end

---Exports all the functions in `self` to the target `scope`.
---Skips values where the key already exists.
---@param scope table? defaults to `_G`, the global environment.
function Module:export(scope)
    scope = scope or _G
    for key, value in pairs(self) do
        scope[key] = scope[key] or value
    end
end

Module.__call = Module.new

Module.__name = "Module"

function Module:__tostring()
    return self.__name
end

return Module

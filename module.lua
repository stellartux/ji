---@class Module
---Module utility functions.
local Module = { __name = "Module" }
setmetatable(Module, Module)
local mt = { __index = Module }

---Create a new module.
---@param init table|string
---@return Module
function Module:__call(init)
    local module = type(init) == "table" and init or {}
    if type(init) == "string" then
        module.__name = init
    end
    return setmetatable(module, mt)
end

--- Exports all the functions in `self` to the target `scope`. Skips keys which
--- start with an underscore and values where the key already exists on `scope`.
---@param scope table? defaults to `_G`, the global environment.
function Module:export(scope)
    scope = scope or _G
    for key, value in pairs(self) do
        if key:byte() ~= 95 then
            scope[key] = scope[key] or value
        end
    end
end

function Module:__tostring()
    return self.__name
end

return Module

---@class Lens
---A lens is a bijective table, a table where if `t[a] -> b` then `t[b] -> a`.
local Lens = require("ji/class")()

function Lens:new(table)
    local lens = { data = {} }
    setmetatable(lens, self)
    if table then
        for key, value in pairs(table) do
            lens[key] = value
        end
    end
    return lens
end

function Lens:clear()
    rawset(self, "data", {})
end

function Lens:__index(key)
    return rawget(self, "data")[key]
end

Lens.__name = "Lens"

function Lens:__newindex(key, value)
    local previousvalue = rawget(self, "data")[key]
    if previousvalue ~= nil then
        rawget(self, "data")[previousvalue] = nil
    end
    rawget(self, "data")[key] = value
    if value ~= nil then
        local previouskey = rawget(self, "data")[value]
        if previouskey ~= nil then
            rawget(self, "data")[previouskey] = nil
        end
        rawget(self, "data")[value] = key
    end
end

function Lens:__pairs()
    return pairs(rawget(self, "data"))
end

return Lens

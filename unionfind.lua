--- UnionFind https://en.wikipedia.org/wiki/Disjoint-set_data_structure
---@class UnionFind
---@private parent table 
local UnionFind = require("ji/class")("UnionFind")

function UnionFind:new(...)
    local parent = {}
    for i = 1, select("#", ...) do
        local value = select(i, ...)
        parent[value] = value
    end
    return { parent = parent }
end

--- Adds each of the given values to the set union.
function UnionFind:add(...)
    for i = 1, select("#", ...) do
        local value = select(i, ...)
        if self.parent[value] == nil then
            self.parent[value] = value
        end
    end
end

function UnionFind:find(x)
    if not self.parent[x] then return nil end
    while self.parent[x] ~= x do
        x, self.parent[x] = self.parent[x], self.parent[self.parent[x]]
    end
    return x
end

--- Combines the set containing `x` and the set containing `y`
function UnionFind:union(x, y)
    x = self:find(x)
    y = self:find(y)
    if x == nil or y == nil or x == y then return end
    self.parent[x] = y
end

function UnionFind:__len()
    local result = 0
    for _ in pairs(self.parent) do result = result + 1 end
    return result
end

--- Iterates over `value, parent` pairs 
function UnionFind:__pairs()
    return next, self.parent, nil
end

return UnionFind

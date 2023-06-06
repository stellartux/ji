---@class BitSet: { [integer]: boolean }
---@field raw integer[]
local BitSet = require("ji/class")("BitSet")

---@param raw string|integer[]?
function BitSet:new(raw)
    if type(raw) == "string" then
        local s = raw:gsub("^%s*BitSet%s*%(?%s*{*", ""):gsub("^}%s*%)?%s*$", "")
        raw = {}
        for m in s:gmatch("[^%s,]+") do
            table.insert(raw, assert(math.tointeger(m), m .. " is not an integer."))
        end
    end
    return { raw = raw or {} }
end

function BitSet:__index(i)
    if type(i) == "number" then
        local hi, lo = (i - 1) // 64 + 1, (i - 1) % 64
        local bits = rawget(self, "raw")[hi]
        return bits and (1 == 1 & bits >> lo) or nil
    else
        return rawget(BitSet, i)
    end
end

function BitSet:__newindex(i, value)
    if i == math.tointeger(i) then
        local hi, mask = (i - 1) // 64 + 1, 1 << i % 64 - 1
        if value then
            self.raw[hi] = (self.raw[hi] or 0) | mask
        elseif self.raw[hi] then
            self.raw[hi] = self.raw[hi] & ~mask
            if self.raw[hi] == 0 then
                self.raw[hi] = nil
            end
        end
    else
        rawset(self, i, value)
    end
end

function BitSet:__len()
    return 64 * #self.raw
end

local function bitsetnext(self, i)
    i = i or 0
    repeat
        i = i + 1
        if self[i] then return i, true end
    until i > #self
end

function BitSet:__pairs()
    return bitsetnext, self, 0
end

function BitSet:repr()
    return "BitSet{" .. table.concat(self.raw, ",") .. "}"
end

return BitSet

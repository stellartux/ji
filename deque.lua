---@class Deque
---A deque is a Double-Ended QUEue.
local Deque = require("ji/class")("Deque")

---Create a new deque from a list. Creates an empty deque if no list is passed.
---@param list table
---@return Deque
function Deque:new(list)
    local deque = list and { table.unpack(list) } or {}
    setmetatable(deque, self)
    return deque
end

---Append the other deque to the end of the deque.
---@param other Deque
---@return Deque self
function Deque:append(other)
    table.move(other, 1, #other, #self + 1, self)
    return self
end

---Create a shallow copy of the deque.
function Deque:copy()
    return Deque:new(self)
end

---Empty the deque, reseting it to its initial state.
function Deque:empty()
    for index in ipairs(self) do
        self[index] = nil
    end
    return self
end

function Deque:isempty()
    return self[1] == nil
end

---Remove a value from the end of the deque.
function Deque:pop()
    assert(not self:isempty(), "Deque is empty")
    return table.remove(self)
end

---Remove a value from the start of the deque.
function Deque:popfirst()
    assert(not self:isempty(), "Deque is empty")
    return table.remove(self, 1)
end

---Prepend the other deque to the start of the deque.
---@param other Deque
---@return Deque self
function Deque:prepend(other)
    table.move(self, 1, #self, #other + 1)
    table.move(other, 1, #other, 1, self)
    return self
end

---Add a value to the end of the deque.
---@param value any
---@return Deque self
function Deque:push(value)
    table.insert(self, value)
    return self
end

---Add a value to the start of the deque.
---@param value any
---@return Deque self
function Deque:pushfirst(value)
    table.insert(self, 1, value)
    return self
end

---Reverse the deque in place.
---@return Deque self
function Deque:reverse()
    for low = 1, #self // 2 do
        local high = #self - low + 1
        self[low], self[high] = self[high], self[low]
    end
    return self
end

Deque.shift = Deque.popfirst

Deque.unshift = Deque.pushfirst

---@param other Deque
function Deque:__eq(other)
    if #self ~= #other then
        return false
    end
    for index, value in ipairs(self) do
        if other[index] ~= value then
            return false
        end
    end
    return true
end

Deque.__index = Deque
Deque.__name = "Deque"

function Deque:__tostring()
    return self.__name .. "{" .. table.concat(self, ", ") .. "}"
end

return Deque

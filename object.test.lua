local Object = require "ji/object"

local object = Object:new({ a = 0 })

assert(Object.isextensible(object), "New object should be extensible.")
assert(not Object.issealed(object), "New object should not be sealed.")
assert(not Object.isfrozen(object), "New object should not be frozen.")

assert(object.a == 0, "Default values on a new object should be accessible.")
object.a = 1
assert(object.a == 1, "Should be able to modify default values on a new object.")
object.b = 2
assert(object.b == 2, "Should be able to extend a new object.")
object.b = 3
assert(object.b == 3, "Should be able to modify new values on a new object.")

Object.preventextensions(object)

assert(not Object.isextensible(object),
    "Non-extensible object should not be extensible.")
assert(not Object.issealed(object),
    "Non-extensible object should not be sealed.")
assert(not Object.isfrozen(object),
    "Non-extensible object should not be frozen.")

object.c = 4
assert(object.c == nil, "Should not be able to extend non-extensible objects.")
object.b = 5
assert(object.b == 5, "Should be able to modify non-extensible objects.")
object.b = nil
assert(object.b == nil,
    "Should be able to remove value from non-extensible objects")
object.b = 6
assert(object.b == nil,
    "Should not be able to add removed values to non-extensible objects.")

Object.seal(object)

assert(not Object.isextensible(object),
    "Sealed object should not be extensible.")
assert(Object.issealed(object), "Sealed object should be sealed.")
assert(not Object.isfrozen(object), "Sealed object should not be frozen.")

object.a = 7
assert(object.a == 7)

Object.freeze(object)

assert(not Object.isextensible(object),
    "Frozen object should not be extensible.")
assert(Object.issealed(object), "Frozen object should be sealed.")
assert(Object.isfrozen(object), "Frozen object should be frozen.")

-- local wrapped = {}
-- setmetatable(wrapped, {
--     __add = function()
--         return true
--     end,
-- })
-- object = Object:new(wrapped)
-- assert(object + object, "Should proxy metamethods for wrapped tables.")

print("object.lua - Tests passed.")

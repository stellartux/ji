local Set = require "ji/set"

local set = Set:new()

set:add(1)
set:add(2)
set:add(3)
assert(#set == 3, "Should have 3 elements.")
assert(set:contains(1), "Should contain 1.")
assert(set:contains(2), "Should contain 2.")
assert(set:contains(3), "Should contain 3.")

local other = Set { 1, 2, 3 }
assert(set == other, "Equal sets should be equal.")
set:delete(1)
set:add(4)
assert(set == Set { 2, 3, 4 }, "Should be able to delete elements.")

local union = set:union(other)
local intersection = set:intersect(other)
assert(set ~= other, "Unequal sets should not be equal.")
assert(union == Set { 1, 2, 3, 4 }, "Set union")
assert(tostring(union) == "Set{1, 2, 3, 4}")
assert(intersection == Set { 2, 3 }, "Set intersection")

print("set.lua - Tests passed.")

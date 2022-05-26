local Lens = require "ji/lens"

local lens = Lens:new()

lens["a"] = "b"
assert(lens["a"] == "b", "Should work as a regular lookup.")
assert(lens["b"] == "a", "Should work as reverse lookup")

lens["a"] = "c"
assert(lens["a"] == "c", "Should be able to mutate lookups.")
assert(lens["c"] == "a", "Should be able to mutate reverse lookups.")
assert(lens["b"] == nil, "Should clear reverse lookups when codomain mutates.")

lens["d"] = "a"
assert(lens["d"] == "a", "Should be able to lookup with reverse mutation.")
assert(lens["a"] == "d",
    "Should be able to mutate lookup with reverse mutation.")
assert(lens["c"] == nil,
    "Should clear reverse lookups when reverse domain mutates.")

for key, value in pairs(lens) do
    assert(type(key) == "string" and type(value) == "string",
        "Should be able to iterate through pairs in a lens.")
end

print("lens.lua - Tests passed.")

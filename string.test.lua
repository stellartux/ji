dofile("ji/string.lua")

local expected = { "hello", "to", "the", "world" }
local index = 1

for word in string.gsplit("hello to the world", "%s") do
    assert(word == expected[index],
        "Expected " .. expected[index] .. " but got " .. word)
    index = index + 1
end

assert(string.rpad("hello", 11) == "hello      ", "rpad")
assert(string.lpad("world", 11) == "      world", "lpad")
assert(string.lpad("!", 11, "!") == "!!!!!!!!!!!", "lpad, not whitespace")
assert(string.rpad("!", 11, "!") == "!!!!!!!!!!!", "rpad, not whitespace")

assert(string.rstrip("hello      ") == "hello", "rstrip")
assert(string.lstrip("      world") == "world", "lstrip")
assert(string.lstrip("!!!!!!!!!!!h", "!") == "h", "lstrip, not whitespace")
assert(string.rstrip("w!!!!!!!!!!!", "!") == "w", "rstrip, not whitespace")
assert(string.strip("     wooooo       ") == "wooooo", "strip")
assert(string.strip("......wooooo......", "%.") == "wooooo",
    "strip, not whitespace")

print("string - Tests passed.")

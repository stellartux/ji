local String = require("ji/string")
local Table = require("ji/table")
local Iterators = require("ji/iterators")

local expected = { "hello", "to", "the", "world" }
local index = 1

for word in String.gsplit("hello to the world", "%s") do
    assert(word == expected[index],
        "Expected " .. expected[index] .. " but got " .. word)
    index = index + 1
end

assert(String.rpad("hello", 11) == "hello      ", "rpad")
assert(String.lpad("world", 11) == "      world", "lpad")
assert(String.lpad("!", 11, "!") == "!!!!!!!!!!!", "lpad, not whitespace")
assert(String.rpad("!", 11, "!") == "!!!!!!!!!!!", "rpad, not whitespace")

assert(String.rstrip("hello      ") == "hello", "rstrip")
assert(String.lstrip("      world") == "world", "lstrip")
assert(String.lstrip("!!!!!!!!!!!h", "!") == "h", "lstrip, not whitespace")
assert(String.rstrip("w!!!!!!!!!!!", "!") == "w", "rstrip, not whitespace")
assert(String.strip("     wooooo       ") == "wooooo", "strip")
assert(String.strip("......wooooo......", "%.") == "wooooo",
    "strip, not whitespace")

assert(String.chomp("hello\n") == "hello", "Should chomp a Unix newline.")
assert(String.chomp("hello\r\n") == "hello", "Should chomp a Windows newline.")
assert(String.chomp("hello\nworld\n\n") == "hello\nworld\n",
    "Should only chomp the final newline.")

assert(String.startswith("hello world", "hello"),
    "Should find matches at the start.")
assert(not String.startswith("world hello", "hello"),
    "Should not find matches at the end.")
assert(not String.endswith("hello world", "hello"),
    "Should not find matches at the start.")
assert(String.endswith("world hello", "hello"),
    "Should find matches at the end.")

assert(String.isascii("Hello, world!"), "Should recognize ASCII characters.")
assert(not String.isascii("Hello, world! 👋🌍"),
    "Should recognize non ASCII characters.")

assert(Table.equallist(Iterators.collect(String.eachchar("woo")), { "w", "o", "o" }))
assert(Table.equallist(Iterators.collect(String.eachbyte("yeah")), { 121, 101, 97, 104 }))

print("String - Tests passed.")

require("ji/string")

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

assert(string.chomp("hello\n") == "hello", "Should chomp a Unix newline.")
assert(string.chomp("hello\r\n") == "hello", "Should chomp a Windows newline.")
assert(string.chomp("hello\nworld\n\n") == "hello\nworld\n",
    "Should only chomp the final newline.")

assert(string.startswith("hello world", "hello"),
    "Should find matches at the start.")
assert(not string.startswith("world hello", "hello"),
    "Should not find matches at the end.")
assert(not string.endswith("hello world", "hello"),
    "Should not find matches at the start.")
assert(string.endswith("world hello", "hello"),
    "Should find matches at the end.")

assert(string.isascii("Hello, world!"), "Should recognize ASCII characters.")
assert(not string.isascii("Hello, world! 👋🌍"),
    "Should recognize non ASCII characters.")

print("string - Tests passed.")

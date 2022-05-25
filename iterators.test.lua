local iterators = require("ji/iterators")

local iter = iterators.stateful(iterators.countfrom())

assert(iter() == 1, "1")
assert(iter() == 2, "2")
assert(iter(true) == 3, "3p1")
assert(iter(true) == 3, "3p2")
assert(iter(true) == 3, "3p3")
assert(iter() == 3, "3")
assert(iter() == 4, "4")
assert(iter(true) == 5, "5p1")
assert(iter() == 5, "5")
assert(iter() == 6, "6")

iter = iterators.stateful(iter)

assert(iter(true) == 7, "7p1")
assert(iter(true) == 7, "7p2")
assert(iter() == 7, "7")
assert(iter() == 8, "8")
assert(iter(true) == 9, "9p1")
assert(iter() == 9, "9")
assert(iter() == 10, "10")

print("iterators - Tests passed.")

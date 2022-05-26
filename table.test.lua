local Table = require("ji/table")

print("Table.equal(...)")
local t = { a = 1, b = 2 }
assert(Table.equal(t, t))
assert(Table.equal(t, { a = 1, b = 2 }))
assert(not Table.equal(t, { c = 3, b = 2 }))
assert(not Table.equal(t, { a = 3, b = 4 }))
assert(not Table.equal(t, { a = 1, b = 2, c = 3 }))
assert(not Table.equal({ a = 1, b = 2, c = 3 }, t))

print("Table.equallist(...)")
local l = { 1, 2, 3 }
assert(Table.equallist(l, l))
assert(Table.equallist(l, { 1, 2, 3 }))
assert(not Table.equallist(l, { 2, 3, 4 }))
assert(not Table.equallist(l, { 1, 2, 3, 4 }))

print("Table - Test passed.")

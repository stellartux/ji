local Table = require("ji/table")

print("Table")
print("    equal(...)")
local t = { a = 1, b = 2 }
assert(Table.equal(t, t))
assert(Table.equal(t, { a = 1, b = 2 }))
assert(not Table.equal(t, { c = 3, b = 2 }))
assert(not Table.equal(t, { a = 3, b = 4 }))
assert(not Table.equal(t, { a = 1, b = 2, c = 3 }))
assert(not Table.equal({ a = 1, b = 2, c = 3 }, t))

print("    equallist(...)")
local l = { 1, 2, 3 }
assert(Table.equali(l, l))
assert(Table.equali(l, { 1, 2, 3 }))
assert(not Table.equali(l, { 2, 3, 4 }))
assert(not Table.equali(l, { 1, 2, 3, 4 }))

print("    reverse()")
assert(Table.reverse({ 1, 2, 3 }), { 3, 2, 1 })
assert(Table.reverse({ 1, 2, 3, 4 }), { 4, 3, 2, 1 })
assert(Table.reverse({}), {})
assert(Table.reverse({ 1, 2, 3 }, 1, 2), { 2, 1, 3 })
assert(Table.reverse({ 1, 2, 3 }, 2, 3), { 1, 3, 2 })
assert(Table.reverse({ 1, 2, 3, 4 }), { 4, 3, 2, 1 })
assert(Table.reverse({ 1, 2, 3, 4 }, 1, 2), { 2, 1, 3, 4 })
assert(Table.reverse({ 1, 2, 3, 4 }, 2, 3), { 1, 3, 2, 4 })
assert(Table.reverse({ 1, 2, 3, 4 }, 1, 3), { 3, 2, 1, 4 })
assert(Table.reverse({ 1, 2, 3, 4 }, 2, 4), { 1, 4, 3, 2 })

print("Table - Test passed.")

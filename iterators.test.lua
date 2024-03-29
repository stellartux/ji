---@diagnostic disable: undefined-global

require("ji/iterators"):export()
local Table = require("ji/table")

print("Testing iterators")

print("    stateful(...)\n    countfrom(...)")
local iter = stateful(countfrom())

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

iter = stateful(iter)

assert(iter(true) == 7, "7p1")
assert(iter(true) == 7, "7p2")
assert(iter() == 7, "7")
assert(iter() == 8, "8")
assert(iter(true) == 9, "9p1")
assert(iter() == 9, "9")
assert(iter() == 10, "10")

print("    partition(...)")
iter = take(3, partition(3, countfrom(10)))
assert(Table.equali(iter(), { 10, 11, 12 }))
assert(Table.equali(iter(), { 13, 14, 15 }))
assert(Table.equali(iter(), { 16, 17, 18 }))
assert(not iter())

iter = take(3, partition(2, 1, countfrom(19)))
assert(Table.equali(iter(), { 19, 20 }))
assert(Table.equali(iter(), { 20, 21 }))
assert(Table.equali(iter(), { 21, 22 }))
assert(not iter())

iter = take(3, partition(5, 2, countfrom(23)))
assert(Table.equali(iter(), { 23, 24, 25, 26, 27 }))
assert(Table.equali(iter(), { 25, 26, 27, 28, 29 }))
assert(Table.equali(iter(), { 27, 28, 29, 30, 31 }))
assert(not iter())

iter = partition(3, 2, take(7, countfrom(32)))
assert(Table.equali(iter(), { 32, 33, 34 }))
assert(Table.equali(iter(), { 34, 35, 36 }))
assert(Table.equali(iter(), { 36, 37, 38 }))
assert(Table.equali(iter(), { 38 }))
assert(not iter())

iter = partition(5, 2, take(7, countfrom(39)))
assert(Table.equali(iter(), { 39, 40, 41, 42, 43 }))
assert(Table.equali(iter(), { 41, 42, 43, 44, 45 }))
assert(Table.equali(iter(), { 43, 44, 45 }))
assert(Table.equali(iter(), { 45 }))
assert(not iter())

print("    zip(...)")
iter = zip({ ipairs({ 10, 20, 30 }) }, { ipairs({ 15, 25, 35 }) })
assert(Table.equali(table.pack(iter()), { 1, 10, 1, 15 }))
assert(Table.equali(table.pack(iter()), { 2, 20, 2, 25 }))
assert(Table.equali(table.pack(iter()), { 3, 30, 3, 35 }))

print("    extrema(...)")
assert(Table.equali(table.pack(extrema(ipairs({ 32, 45, -50, 45 }))), { 3, -50, -50, 2, 45, 45 }))
assert(Table.equali(table.pack(extrema(math.abs, ipairs({ 32, 45, -50, 45 }))), { 1, 32, 32, 3, -50, 50 }))

print("    cycle(...)")
assert(Table.equali(collect(cycle(3, ipairs { 10, 20, 30 })), { 10, 20, 30, 10, 20, 30, 10, 20, 30 }))

print("iterators - Tests passed.")

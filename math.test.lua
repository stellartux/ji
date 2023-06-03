---@diagnostic disable: undefined-global
local Math = require("ji/math")
local Table = require("ji/table")
require("ji/iterators"):export()

print("math")

print("    digits")
assert(Table.equali(Math.digits(123), { 3, 2, 1 }))
assert(Table.equali(Math.digits(-123), { 3, 2, -1 }))
assert(Table.equali(Math.digits(-1123), { 3, 2, 1, -1 }))
assert(Table.equali(Math.digits(42, 2), { 0, 1, 0, 1, 0, 1 }))
assert(Table.equali(Math.digits(42, 16), { 10, 2 }))
assert(Table.equali(Math.digits(255, 16), { 15, 15 }))

print("    eachdigit")
assert(Table.equali(collect(Math.eachdigit(123)), { 3, 2, 1 }))
assert(Table.equali(collect(Math.eachdigit(-123)), { 3, 2, -1 }))
assert(Table.equali(collect(Math.eachdigit(-1123)), { 3, 2, 1, -1 }))
assert(Table.equali(collect(Math.eachdigit(42, 2)), { 0, 1, 0, 1, 0, 1 }))
assert(Table.equali(collect(Math.eachdigit(42, 16)), { 10, 2 }))
assert(Table.equali(collect(Math.eachdigit(255, 16)), { 15, 15 }))

print("    permutationsl")
local p = Math.permutationsl({ 2, 3, 1 })
assert(Table.equali(p(), { 1, 2, 3 }))
assert(Table.equali(p(), { 1, 3, 2 }))
assert(Table.equali(p(), { 2, 1, 3 }))
assert(Table.equali(p(), { 2, 3, 1 }))
assert(Table.equali(p(), { 3, 1, 2 }))
assert(Table.equali(p(), { 3, 2, 1 }))

print("Math - Tests passed.\n")

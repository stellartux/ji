---@diagnostic disable: undefined-global
local Math = require("ji/math")
local Table = require("ji/table")
require("ji/iterators"):export()

assert(Table.equallist(Math.digits(123), { 3, 2, 1 }))
assert(Table.equallist(Math.digits(-123), { 3, 2, -1 }))
assert(Table.equallist(Math.digits(-1123), { 3, 2, 1, -1 }))
assert(Table.equallist(Math.digits(42, 2), { 0, 1, 0, 1, 0, 1 }))
assert(Table.equallist(Math.digits(42, 16), { 10, 2 }))
assert(Table.equallist(Math.digits(255, 16), { 15, 15 }))

assert(Table.equallist(collect(Math.eachdigit(123)), { 3, 2, 1 }))
assert(Table.equallist(collect(Math.eachdigit(-123)), { 3, 2, -1 }))
assert(Table.equallist(collect(Math.eachdigit(-1123)), { 3, 2, 1, -1 }))
assert(Table.equallist(collect(Math.eachdigit(42, 2)), { 0, 1, 0, 1, 0, 1 }))
assert(Table.equallist(collect(Math.eachdigit(42, 16)), { 10, 2 }))
assert(Table.equallist(collect(Math.eachdigit(255, 16)), { 15, 15 }))

print("Math - Tests passed.")

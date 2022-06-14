local Operators = require("ji/operators")

print("Operators")

print("    add")
assert(Operators.add(1, 2, 3) == (1 + 2) + 3, "1 + 2 + 3 == 6")

print("    sub")
assert(Operators.sub(5, 2, 1) == (5 - 2) - 1, "5 - 2 - 1 == 2")

print("    mul")
assert(Operators.mul(3, 4, 5) == (3 * 4) * 5, "3 * 4 * 5 == 60")

print("    div")
assert(Operators.div(30, 6, 2) == (30 / 6) / 2, "30 / 6 / 2 == 2.5")

print("    idiv")
assert(Operators.idiv(30, 6, 2) == (30 // 6) // 2, "30 // 6 // 2 == 2")

print("    pow")
assert(Operators.pow(4, 3, 2) == 4 ^ (3 ^ 2), "4 ^ 3 ^ 2 == 262144")

print("    eq")
assert(Operators.eq(1, 1), "1 == 1")
assert(Operators.eq(1, 1, 1), "1 == 1 == 1")
assert(not Operators.eq(1, 1, 2), "not (1 == 1 == 2)")

print("Operators - tests passed.")

local Matrix = require("matrix")

print("Matrix")

print("    ==")
local matrix = Matrix:new(2, 2)
assert(matrix == matrix, "Matrix equals itself.")
assert(matrix == Matrix:new(2, 2), "Matrix equals identical matrix.")

print("    get")
assert(matrix:get(1, 1) == 0, "Uninitialised matrix has 0 at position [1, 1].")
assert(matrix[1] == matrix:get(1, 1), "One based indexing.")

print("    set")
matrix:set(1, 1, 1)
assert(matrix:get(1, 1) == 1, "Can set values.")

print("Matrix - Tests passed.")

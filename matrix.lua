---@class Matrix
---Matrix algebra
local Matrix = require("ji/class")("Matrix")
local Iterators = require("ji/iterators")
local Operators = require("ji/operators")

Matrix.width = 0
Matrix.height = 0
Matrix.ismatrix = true

---Creates a new matrix.
---@param width integer|number[]|Matrix the number of columns in the matrix, or a list of all the values in the matrix.
---@param height integer? the number of rows in the matrix. Optional if initialised with another Matrix.
---@param init function|number[]|Matrix? a list, matrix or generator function for the initial values of the matrix.
---@return Matrix
---@overload fun(self, values: number[], height: integer): Matrix
function Matrix:new(width, height, init, ...)
    local matrix = {}
    if type(width) == "number" then
        matrix.width = assert(width > 0 and math.tointeger(width),
            "width must be a positive integer.")
    elseif type(width) == "table" then
        ---@diagnostic disable-next-line: undefined-field
        height = math.tointeger(height or width.height)
        assert(#width % height == 0, "Matrix must be rectangular.")
        for key, value in ipairs(width) do
            matrix[key] = value
        end
        matrix.width = #width // height
    end
    matrix.height = assert(height > 0 and math.tointeger(height),
        "height must be a positive integer.")
    if type(init) == "table" then
        for key, value in ipairs(init) do
            matrix[key] = value
        end
    elseif type(init) == "function" then
        for _, value in init, ... do
            table.insert(matrix, value)
        end
    end
    setmetatable(matrix, self)
    return matrix
end

---Adds other to the matrix. Mutates self.
---@param other number|Matrix
function Matrix:add(other)
    return self:apply(Operators.add, other)
end

---Apply the operator to the matrix.
---@param operator function
function Matrix:apply(operator, other)
    if other == nil or type(other) == "number" then
        for index, value in ipairs(self) do
            self[index] = operator(value, other)
        end
    elseif other.ismatrix then
        assert(self:issamesize(other), "Matrices must be the same size.")
        for index, value in ipairs(other) do
            self[index] = operator(self[index], value)
        end
    else
        error("Expected a number or another matrix.")
    end
    return self
end

---@param x integer
---@param y integer?
---@return boolean
function Matrix:checkbounds(x, y)
    if y == nil then
        return x >= 1 and x <= #self
    elseif type(x) == "number" and type(y) == "number" then
        return x >= 1 and x <= self.width and y >= 1 and y <= self.height
    else
        error("Bad arguments to Matrix:checkbounds(): " .. x .. " and " .. y)
    end
end

function Matrix:copy()
    return Matrix:new(self)
end

function Matrix:div(other)
    return Matrix:apply(Operators.div, other)
end

function Matrix:eachrow()
    return Iterators.partition(self.width, self())
end

---@param x integer
---@param y integer
---@param skipcheck boolean?
---@return integer
function Matrix:get(x, y, skipcheck)
    assert(skipcheck or self:checkbounds(x, y), "Access out of bounds.")
    return self[y and (y - 1) * self.width + x or x]
end

function Matrix:idiv(other)
    return self:apply(Operators.idiv, other)
end

---Like ipairs, but 2D. Returns i, j, v for each element of the matrix.
function Matrix:ijpairs()
    local i = 0
    local j = 1
    return function()
        i = i + 1
        if i > self.width then
            i = 1
            j = j + 1
            if j > self.height then return end
        end
        return i, j, self:get(i, j, true)
    end
end

---@param other Matrix
function Matrix:issamesize(other)
    return not not (other and other.ismatrix)
        and self.width == other.width
        and self.height == other.height
end

function Matrix:issquare()
    return self.width == self.height
end

function Matrix:map(fn)
    local result = self:copy()
    for key, value in ipairs(result) do
        result[key] = fn(value)
    end
    return result
end

function Matrix:mul(other)
    return Matrix:apply(Operators.mul, other)
end

function Matrix:pow(n)
    assert(self:issquare(), "Matrix must be square.")
    assert(n >= 0 and math.tointeger(n), "Matrix exponent must be a positive integer.")
    local copy = self:copy()
    -- TODO optimise exponentiation
    while n > 1 do
        self:mul(copy)
        n = n - 1
    end
    return self
end

function Matrix:set(value, x, y)
    assert(self:checkbounds(x, y), "Access out of bounds.")
    self[y and (y - 1) * self.width + x or x] = value
end

function Matrix:sub(other)
    return Matrix:apply(Operators.sub, other)
end

function Matrix:unm()
    return Matrix:mul(-1)
end

function Matrix:__add(other)
    if self:issamesize(other) or type(other) == "number" then
        return self:copy():add(other)
    else
        error("Can't add a " .. type(other) .. " to a Matrix.")
    end
end

function Matrix:__call()
    return ipairs(self)
end

function Matrix:__eq(other)
    if #self ~= #other or self.width ~= other.width then
        return false
    end
    for i, j, v in self:ijpairs() do
        if v ~= other:get(i, j, true) then return false end
    end
    return true
end

function Matrix:__idiv(other)
    return self:copy():idiv(other)
end

function Matrix:__index(key)
    if type(key) == "number" and key >= 1 and key <= #self then
        return 0
    else
        return Matrix[key]
    end
end

function Matrix:__len()
    return self.width * self.height
end

function Matrix:__mul(other)
    return self:copy():mul(other)
end

function Matrix:__pow(n)
    return self:copy():pow(n)
end

function Matrix:__sub(other)
    return self:copy():sub(other)
end

function Matrix:__tostring()
    local result = {}
    for i, row in self:eachrow() do
        result[i] = table.concat(row, ", ")
    end
    return "Matrix("
        .. self.width
        .. ", "
        .. self.height
        .. ", {\n    "
        .. table.concat(result, ",\n    ")
        .. "\n})"
end

function Matrix:__unm()
    return self:copy():unm()
end

return Matrix

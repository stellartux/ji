local Operators = {}

---Convert a 2-ary left associative operator function to an n-ary operator function.
---@param operator function 2-ary left associative
---@return function operator n-ary
local function leftassociative(operator)
    return function(x, ...)
        for i = 1, select('#', ...) do
            x = operator(x, select(i, ...))
        end
        return x
    end
end

---Convert a 2-ary right associative operator function to an n-ary operator function.
---@param operator function 2-ary right associative
---@return function operator n-ary
local function rightassociative(operator)
    return function(...)
        local len = select('#', ...)
        local x = select(len, ...)
        for i = len - 1, 1, -1 do
            x = operator(select(i, ...), x)
        end
        return x
    end
end

---Convert a 2-ary transitive relation function to an n-ary relation function.
---@generic T
---@param relation fun(l: T, r: T): T 2-ary transitive function
---@return fun(...: T): T relation n-ary
local function transitive(relation)
    return function(x, y, ...)
        for i = 1, select('#', y, ...) do
            y = select(i, y, ...)
            if not relation(x, y) then return false end
            x = y
        end
        return true
    end
end

Operators.add = leftassociative(function(x, y) return x + y end)
Operators.sub = leftassociative(function(x, y) return x - y end)
Operators.mul = leftassociative(function(x, y) return x * y end)
Operators.div = leftassociative(function(x, y) return x / y end)
Operators.mod = leftassociative(function(x, y) return x % y end)
Operators.idiv = leftassociative(function(x, y) return x // y end)
Operators.band = leftassociative(function(x, y) return x & y end)
Operators.bor = leftassociative(function(x, y) return x | y end)
Operators.bxor = leftassociative(function(x, y) return x ~ y end)
Operators.shl = leftassociative(function(x, y) return x << y end)
Operators.shr = leftassociative(function(x, y) return x >> y end)
Operators.concat = leftassociative(function(x, y) return x .. y end)

Operators.pow = rightassociative(function(x, y) return x ^ y end)

Operators.eq = transitive(function(x, y) return x == y end)
Operators.lt = transitive(function(x, y) return x < y end)
Operators.le = transitive(function(x, y) return x <= y end)
Operators.gt = transitive(function(x, y) return x > y end)
Operators.ge = transitive(function(x, y) return x >= y end)

Operators.leftassociative = leftassociative
Operators.rightassociative = rightassociative
Operators.transitive = transitive

return Operators

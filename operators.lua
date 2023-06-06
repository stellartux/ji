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

local function commutativeinner(fn, length, ...)
    if length > 3 then
        return fn(
            commutativeinner(
                fn,
                length - length // 2,
                select(length // 2 + 1, ...)
            ),
            commutativeinner(fn, length // 2, ...)
        )
    elseif length == 3 then
        return fn(..., fn(select(2, ...), (select(3, ...))))
    elseif length == 2 then
        return fn(..., (select(2, ...)))
    end
end

--- Convert a 2-ary commutative relation function to an n-ary relation function
--- that performs `log(N)` operations.
---@generic T
---@param relation fun(l: T, r: T): T 2-ary commutative function
---@return fun(...: T): T relation n-ary
local function commutative(relation)
    return function(...)
        return commutativeinner(relation, select('#', ...), ...)
    end
end

Operators.add = commutative(function(x, y) return x + y end)
Operators.sub = leftassociative(function(x, y) return x - y end)
Operators.mul = commutative(function(x, y) return x * y end)
Operators.div = leftassociative(function(x, y) return x / y end)
Operators.mod = leftassociative(function(x, y) return x % y end)
Operators.idiv = leftassociative(function(x, y) return x // y end)
Operators.band = commutative(function(x, y) return x & y end)
Operators.bor = commutative(function(x, y) return x | y end)
Operators.bxor = commutative(function(x, y) return x ~ y end)
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
Operators.commutative = commutative

return Operators

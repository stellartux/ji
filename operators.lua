local Operators = {}

function Operators.add(x, y, ...)
    return y and Operators.add(x + y, ...) or x
end

function Operators.sub(x, y, ...)
    return y and Operators.sub(x - y, ...) or x
end

function Operators.mul(x, y, ...)
    return y and Operators.mul(x * y, ...) or x
end

function Operators.div(x, y, ...)
    return y and Operators.add(x / y, ...) or x
end

function Operators.mod(x, y, ...)
    return y and Operators.add(x % y, ...) or x
end

function Operators.idiv(x, y, ...)
    return y and Operators.add(x // y, ...) or x
end

function Operators.pow(...)
    -- reduce right to left
    -- to match the order of the operator
    local args = table.pack(...)
    local value = args[#args]
    for i = #args - 1, 1, -1 do
        value = args[i] ^ value
    end
    return value
end

function Operators.band(x, y, ...)
    return y and Operators.band(x & y, ...) or x
end

function Operators.bor(x, y, ...)
    return y and Operators.bor(x | y, ...) or x
end

function Operators.bxor(x, y, ...)
    return y and Operators.bxor(x ~ y, ...) or x
end

function Operators.shl(x, y, ...)
    return y and Operators.shl(x << y, ...) or x
end

function Operators.shr(x, y, ...)
    return y and Operators.shr(x >> y, ...) or x
end

function Operators.concat(x, y, ...)
    return y and Operators.concat(x .. y, ...) or x
end

return Operators

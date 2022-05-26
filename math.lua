---More mathematical operations.
local Math = require("ji/module")()

local Table = require("ji/table")
local Iterators = require("ji/iterators")

---The digits of the given integer, from least significant to most significant.
---@param n integer
---@param base integer? optional, defaults to `10`
---@return integer[]
function Math.digits(n, base)
    n = math.tointeger(n)
    if not n then
        error("n must be an integer.")
    elseif n < 0 then
        local digits = Math.digits(-n, base)
        digits[#digits] = -digits[#digits]
        return digits
    end
    if base and (not math.tointeger(base) or base < 1) then
        error("base must be a positive integer.")
    elseif not base then
        base = 10
    end
    local result = {}
    repeat
        table.insert(result, math.fmod(n, base))
        n = n // base
    until n == 0
    return result
end

local function nextdigit(base, n)
    if n and n ~= 0 then return n // base, math.fmod(n, base) end
end

---The digits of the given integer, from least significant to most significant.
---@param n integer
---@param base integer? optional, defaults to `10`
---@return function iterator
function Math.eachdigit(n, base)
    n = assert(math.tointeger(n), "n must be an integer.")
    if base then
        base = math.tointeger(base)
        assert(base and base > 0, "base must be a positive integer.")
    else
        base = 10
    end
    if n == 0 then
        return Iterators.repeated(0, 1)
    elseif n > 0 then
        return nextdigit, base, n
    elseif n < 0 then
        return function(digits)
            local key, value = digits()
            if key then
                return key, value * (digits(true) and 1 or -1)
            end
        end, Iterators.stateful(nextdigit, base, -n)
    end
end

local function gcd(x, y)
    return y == 0 and x or gcd(y, x % y)
end

---Calculates the greatest common divisor of the given integers.
---@param x integer
---@param y integer?
---@param ... integer
function Math.gcd(x, y, ...)
    y = math.tointeger(y)
    if y then
        return Math.gcd(gcd(x, y), ...)
    else
        return x
    end
end

---Calculates the least common multiple of the given integers.
---@param x integer
---@param y integer
---@param ... integer?
function Math.lcm(x, y, ...)
    if y then
        return Math.lcm(math.abs(x) * (math.abs(y) / gcd(x, y)), ...)
    else
        return x
    end
end

local function primes(cache, prime)
    prime = Table.find(cache, true, prime + 1)
    if prime then
        for composite = prime * prime, #cache, prime do
            cache[composite] = false
        end
    end
    return prime, prime
end

---Lazily calculates each prime below the limit.
---@param max integer? defaults to `229`, the first 50 primes.
function Math.primes(max)
    if max then
        max = math.tointeger(max)
        assert(max and max > 0, "max must be an positive integer.")
    else
        max = 229
    end
    local cache = Table.fill({}, true, 1, max)
    cache[1] = false
    return primes, cache, 1
end

return Math

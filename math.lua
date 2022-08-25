---More mathematical operations.
local Math = require("ji/module")()

local Table = require("ji/table")
local Iterators = require("ji/iterators")

---The digits of the given integer, from least significant to most significant.
---@param n integer
---@param base integer? optional, defaults to `10`
---@return integer[]
function Math.digits(n, base)
    return Iterators.collect(Math.eachdigit(n, base))
end

local function nextdigit(base, n)
    if n and n ~= 0 then return n // base, math.fmod(n, base) end
end

---The digits of the given integer, from least significant to most significant.
---@param n integer
---@param base integer? optional, defaults to `10`
---@return function iterator, ...
function Math.eachdigit(n, base)
    n = assert(math.tointeger(n), "n must be an integer.")
    base = base and assert(base > 0 and math.tointeger(base),
        "base must be a positive integer.") or 10
    if math.abs(n) < base then
        return Iterators.repeated(n, 1)
    elseif n > 0 then
        return nextdigit, base, n
    elseif n < 0 then
        return function(digits)
            local key, value = digits()
            if key then
                return key, value * (digits(true) and 1 or -1)
            end
        end, Iterators.stateful(nextdigit, base, -n)
    else
        error("Unreachable eachdigit " .. n .. " " .. base)
    end
end

---@param x integer
---@param y integer
local function gcd(x, y)
    return y == 0 and x or gcd(y, x % y)
end

---Calculates the greatest common divisor of the given integers.
---@param x integer
---@param y integer?
---@param ... integer?
function Math.gcd(x, y, ...)
    y = math.tointeger(y)
    return y and Math.gcd(gcd(x, y), ...) or x
end

---Calculates the least common multiple of the given integers.
---@param x integer
---@param y integer?
---@param ... integer?
function Math.lcm(x, y, ...)
    return y and Math.lcm(math.abs(x) * (math.abs(y) // gcd(x, y)), ...) or x
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
    max = max and assert(max > 0 and math.tointeger(max),
        "max must be an positive integer.") or 229
    local cache = Table.fill({}, true, 1, max)
    cache[1] = false
    return primes, cache, 1
end

return Math

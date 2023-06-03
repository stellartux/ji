---More mathematical operations.
local Math = require("ji/module")("Math")

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

local function lcm(x, y)
    return math.abs(x) * (math.abs(y) // gcd(x, y))
end
---Calculates the least common multiple of the given integers.
---@param x integer
---@param ... integer
---@return integer
function Math.lcm(x, ...)
    for i in 1, select("#", ...) do
        x = lcm(x, select(i, ...))
    end
    return x
end

local function cmp(a, b)
    if a < b then
        return -1
    elseif a > b then
        return 1
    else
        return 0
    end
end

--- Iterate over each permutation of the given list.
--- See https://en.wikipedia.org/wiki/Steinhaus%E2%80%93Johnson%E2%80%93Trotter_algorithm#Even's_speedup
---@generic T
---@param list T[]
---@return fun(): permutation: T[]?
function Math.permutations(list)
    assert(type(list) == "table" and #list > 0)

    -- Initially, the direction of the number 1 is zero,
    -- and all other elements have a negative direction:
    local p = { { 1, 0 } }
    for i = 2, #list do
        p[i] = { i, -1 }
    end
    local i

    return function()
        if not i then
            i = #p
            local result = {}
            for j = 1, i do
                result[j] = list[p[j][1]]
            end
            return result
        elseif i == 0 then
            return
        end

        -- At each step, the algorithm finds the greatest element with
        -- a nonzero direction, and swaps it in the indicated direction:
        local t = table.remove(p, i)
        i = i + t[2]
        table.insert(p, i, t)

        -- If this causes the chosen element to reach the first or last
        -- position within the permutation, or if the next element in
        -- the same direction is greater than the chosen element, the
        -- direction of the chosen element is set to zero:
        if i == 1 or i == #p or p[i + t[2]][1] > t[1] then
            t[2] = 0
        end

        -- After each step, all elements greater than the chosen element
        -- which previously had direction zero have their directions
        -- set to indicate motion toward the chosen element. That is,
        -- positive for all elements between the start of the permutation
        -- and the chosen element, and negative for elements toward the
        -- end:
        local result = {}
        local maxv, maxi = -math.huge, 0
        for j, pair in ipairs(p) do
            result[j] = list[pair[1]]
            if pair[1] > t[1] then
                pair[2] = cmp(i, j)
            end
            if pair[1] > maxv and pair[2] ~= 0 then
                maxv = pair[1]
                maxi = j
            end
        end
        i = maxi
        return result
    end
end

--- Each permutation of the given list in lexicographical order.
--- See https://en.wikipedia.org/wiki/Permutation#Generation_in_lexicographic_order
---@generic T
---@param list T[]
---@param cmp? fun(a: T, b: T): boolean defaults to `a < b`
---@return fun(): permutation: T[]?
function Math.permutationsl(list, cmp)
    assert(type(list) == "table")
    cmp = cmp or function(a, b) return a < b end
    local a
    return function()
        if not a then
            a = Table.copy(list)
            table.sort(a, cmp)
            return a
        end

        -- Find the largest index k such that a[k] < a[k + 1]. If no such index
        -- exists, the permutation is the last permutation.
        local k
        for i = #a - 1, 1, -1 do
            if cmp(a[i], a[i + 1]) then
                k = i
                break
            end
        end
        if not k then return end

        -- Find the largest index l greater than k such that a[k] < a[l].
        local l
        for i = #a, k + 1, -1 do
            if cmp(a[k], a[i]) then
                l = i
                break
            end
        end

        -- Swap the value of a[k] with that of a[l].
        a[k], a[l] = a[l], a[k]

        -- Reverse the sequence from a[k + 1] up to and including the final element a[n].
        return Table.reverse(a, k + 1)
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

--- Lazily calculates each prime below the limit with the Sieve of Eratosthenes.
---@param max integer? defaults to `229`, the first 50 primes.
function Math.primes(max)
    max = max and assert(max > 0 and math.tointeger(max),
        "max must be a positive integer.") or 229
    local cache = Table.fill({}, true, 1, max)
    cache[1] = false
    return primes, cache, 1
end

return Math

#!/usr/bin/env lua
local usage = #{} and --[[ code visible to Julia
"""
Usage:

    julia primes.lua n

Exit with error code 0 if n is prime, or error code 1 if n is not prime.

    julia /primes.lua command args...

Command can be one of:

    - help              show this text
    - factor n          the prime factorization of n
    - isprime n         "true" or "false" if n is prime
    - nextprime n       the next prime, not less than n
    - prevprime n       the previous prime, not greater than n
    - prime n           the n-th prime
    - radical n         the radical of n

Multiple commands can be issued, Commands can use Unix style flags.

    \$ lua primes.lua isprime 9 10 11 prime 3 4 5 factor 99
    false
    false
    true
    5
    7
    11
    3^2 * 11
    \$ lua primes.lua --isprime=3 --factor=441
    5
    3^2 * 7^2

"""
using Primes

function main()
    fn = exit ∘ Int ∘ (!) ∘ Primes.isprime
    for arg in ARGS
        n = tryparse(Int, arg)
        if !isnothing(n)
            show(stdout, MIME("text/plain"), fn(n))
            println()
        elseif arg == "help"
            println(usage)
        else
            fn = if arg == "prime"
                Primes.prime
            elseif arg == "factor"
                Primes.factor
            elseif arg == "isprime"
                Primes.isprime
            elseif arg == "nextprime"
                Primes.nextprime
            elseif arg == "prevprime"
                Primes.prevprime
            elseif arg == "prime"
                Primes.prime
            elseif arg == "primes"
                Primes.primes
            elseif arg == "radical"
                Primes.radical
            else
                error("Unrecognised argument: $(arg)")
            end
        end
    end
end
main()

#= code visible to Lua ]]

    [=[
Usage:

    ./primes.lua n

Exit with error code 0 if n is prime, or error code 1 if n is not prime.

    ./primes.lua command args...

Command can be one of:

   - help              show this text
   - factor n          the prime factorization of n
   - isprime n         "true" or "false" if n is prime
   - nextprime n       the next prime, not less than n
   - prevprime n       the previous prime, not greater than n
   - prime n           the n-th prime
   - radical n         the radical of n

Multiple commands can be issued, Commands can use Unix style flags.

    $ lua primes.lua isprime 9 10 11 prime 3 4 5 factor 99
    false
    false
    true
    5
    7
    11
    3^2 * 11
    $ lua primes.lua --isprime=3 --factor=441
    5
    3^2 * 7^2
]=]

local mt = {
    __name = "Primes",
    export = function(self, scope)
        scope = scope or _G
        for key, value in pairs(self) do
            if key:byte() ~= 95 then
                scope[key] = scope[key] or value
            end
        end
    end
}
mt.__index = mt
local Primes = setmetatable({}, mt)
local raw = { 0x40b6894d325a65b7 }

---@param n integer
---@return integer, integer
local function index(n)
    n = (n - 2) // 2
    return n // 64 + 1, 1 << n % 64
end

---@param n integer
local function getindex(n)
    if n > 2 and n % 2 == 1 then
        local i, mask = index(n)
        return raw[i] & mask ~= 0
    else
        return n == 2
    end
end

---@param n integer
---@param value boolean
local function setindex(n, value)
    if n > 2 and n % 2 == 1 then
        local i, mask = index(n)
        raw[i] = value and raw[i]| mask or raw[i] & ~mask
    end
end

--- Adds all primes up to at least n to the cache.
---@param n integer
local function generateprimes(n)
    local minlen = 1 + (n - 3) // 128
    if minlen > #raw then
        for _ = #raw + 1, minlen do
            table.insert(raw, -1)
        end
        local maxval = minlen * 128 + 1
        for p = 3, maxval, 2 do
            if getindex(p) then
                for c = p * p, maxval, p + p do
                    setindex(c, false)
                end
            end
        end
    end
end

---@param n integer
---@return boolean -- true if `n` is a prime number
---@nodiscard
function Primes.isprime(n)
    n = assert(math.tointeger(n), "n must be an integer.")
    local rootn = math.floor(math.sqrt(n))
    generateprimes(rootn)
    if index(n) <= #raw then
        return getindex(n)
    end
    for prime in Primes.eachprime(rootn) do
        if n % prime == 0 then
            return false
        end
    end
    return true
end

---@param hi integer
---@param i integer
---@return integer, integer
---@overload fun(hi: integer, i: integer)
local function nextprime(hi, i)
    while i < hi do
        i = i + 1
        if Primes.isprime(i) then return i end
    end
end

--- Iterator over each prime (from `lo`, if specified) up to `hi`.
---@param lo integer
---@param hi integer?
function Primes.eachprime(lo, hi)
    if not hi then lo, hi = 2, lo end
    generateprimes(hi)
    return nextprime, hi, lo - 1
end

local primelistmt = {
    __tostring = function(self)
        return table.concat(self, '\n')
    end
}

--- Returns a collection of the prime numbers (from lo, if specified) up to hi.
---@param lo integer
---@param hi integer
---@overload fun(hi: integer): integer[]
---@return integer[]
function Primes.primes(lo, hi)
    local result = {}
    for prime in Primes.eachprime(lo, hi) do
        table.insert(result, prime)
    end
    return setmetatable(result, primelistmt)
end

--- The `i`-th smallest prime not less than `n` (in particular, `nextprime(p) == p`
--- if `p` is prime). If `i < 0`, this is equivalent to `prevprime(n, -i)`.
---@param n integer
---@param i integer defaults to 1
---@return integer?
---@overload fun(n: integer): integer
function Primes.nextprime(n, i)
    i = i and assert(math.tointeger(i), "expected an integer") or 1
    n = math.max(2, (assert(math.tointeger(n), "expected an integer")))
    assert(i ~= 0, "can't get the zeroth prime")
    local step = i > 0 and 1 or -1
    if Primes.isprime(n) then i = i - step end
    while i ~= 0 do
        i = i - step
        n = n + step
        while not Primes.isprime(n) do
            n = n + step
            if n < 2 then return end
        end
    end
    return n
end

---@param n integer
---@param i integer? defaults to 1
function Primes.prevprime(n, i)
    return Primes.nextprime(n, -(i or 1))
end

--- The i-th prime number.
---@param i integer
function Primes.prime(i)
    i = assert(i and i > 0 and math.tointeger(i), "i must be an integer") --[[@as integer]]
    if i == 1 then return 2 end
    generateprimes(math.ceil(i * math.log(i, 2)))
    local n = 1
    for j, data in ipairs(raw) do
        for k = 0, 63 do
            if (data >> k) & 1 == 1 then
                n = n + 1
                if n == i then
                    return 128 * (j - 1) + 3 + 2 * k
                end
            end
        end
    end
end

---@param n integer
---@return integer
function Primes.radical(n)
    local result = 1
    for prime in pairs(Primes.factor(n)) do
        result = result * prime
    end
    return result
end

---@class Primes.factor: table<integer,{ [1]: integer, [2]: integer }>
Primes.factor = require("ji/class")("Primes.factor")

---@param n integer
function Primes.factor:new(n)
    n = assert(math.tointeger(n), "expected an integer")
    local result = {}
    if n <= 0 then
        table.insert(result, { n == 0 and 0 or -1, 1 })
        n = -n
    end
    for prime in Primes.eachprime(n) do
        while n % prime == 0 do
            local i
            for j = 1, #result do
                if result[j][1] >= prime then
                    i = j
                    break
                end
            end
            if result[i] and result[i][1] == prime then
                result[i][2] = result[i][2] + 1
            else
                table.insert(result, i or #result + 1, { prime, 1 })
            end
            n = n // prime
        end
    end
    return result
end

---@return integer
function Primes.factor:tonumber()
    local result = 1
    for prime, exponent in pairs(self) do
        result = result * prime ^ exponent
    end
    return result
end

function Primes.factor:__pairs()
    local i = 0
    ---@return integer, integer
    ---@overload fun(self: Primes.factor, i: integer)
    return function()
        i = i + 1
        if i <= #self then
            return table.unpack(self[i])
        end
    end
end

function Primes.factor:__tostring()
    local result = {}
    for _, pair in ipairs(self) do
        table.insert(result, pair[2] == 1 and pair[1] or table.concat(pair, "^"))
    end
    return table.concat(result, " * ")
end

local function main(args)
    local fn = function(n) os.exit(Primes.isprime(n)) end
    for _, arg in ipairs(args) do
        local n = math.tointeger(arg)
        arg = arg:gsub("^%-+", "")
        if n then
            print(fn(n))
        elseif arg == "help" or arg == "h" then
            print(usage)
        elseif Primes[arg] then
            fn = Primes[arg]
        else
            local cmd, param = arg:match("^(%w+)=(.+)$")
            n = math.tointeger(param)
            if type(rawget(Primes, cmd)) == "function" and n then
                fn = rawget(Primes, cmd)
            else
                print(("Unrecognised argument: %s"):format(arg))
                os.exit(1)
            end
            print(fn(n))
        end
    end
end

if pcall(debug.getlocal, 4, 1) then
    return Primes
else
    main(arg)
end --=#

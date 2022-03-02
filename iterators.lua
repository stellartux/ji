--[[
    Base.Iterators
    https://docs.julialang.org/en/v1/base/iterators/
]] --
--
local Iterators = {}

---Given a 2-argument function `combiner` and an iterator `iterator`,
---return a new iterator that successively applies `combiner` to the previous
---value and the next element of `iterator`.
---@param combiner function lambda with signature `(total, value) -> newtotal`
---@param iterator function
---@return function stateful
function Iterators.accumulate(combiner, init, iterator, iterand, key)
    local total = init
    return function()
        local value
        key, value = iterator(iterand, key)
        if key ~= nil then
            total = combiner(total, value)
            return key, total
        end
    end
end

---Returns true if every value in the iterator satisfies the predicate.
---@param predicate function
---@param iterator function
---@return boolean
function Iterators.all(predicate, iterator, ...)
    for _, value in iterator, ... do
        if not predicate(value) then
            return false
        end
    end
    return true
end

---Returns true if all values of the iterator are equal.
---@param iterator function
function Iterators.allequal(iterator, iterand, key)
    local previous, value
    key, previous = iterator(iterand, key)
    while key ~= nil do
        key, value = iterator(iterand, key)
        if previous ~= value then
            return false
        end
        previous = value
    end
    return true
end

---Returns true if no value appears more than once in the iterator.
---@param iterator function
function Iterators.allunique(iterator, ...)
    local seen = {}
    for _, value in iterator, ... do
        if seen[value] then
            return false
        else
            seen[value] = true
        end
    end
    return true
end

---Returns true if any value in the collection satisfies the predicate.
---@param predicate function defaults to `identity`
function Iterators.any(predicate, iterator, iterand, key)
    if type(iterator) ~= "function" then
        iterator, iterand, key = predicate, iterator, iterand
    end
    for _, value in iterator, iterand, key do
        if predicate(value) then
            return true
        end
    end
    return false
end

---Convert an iterator into a table.
---@param iterator function
---@return table
function Iterators.collect(iterator, ...)
    local result = {}
    for key, value in iterator, ... do
        result[key] = value
    end
    return result
end

---@return any value
local function identity(value)
    return value
end

---Counts how many items satisfy the predicate, or how many truthy items are in
---the iterator if no predicate is provided.
---@param predicate function optional, defaults to `identity`
---@return integer
function Iterators.count(predicate, iterator, iterand, key)
    if type(iterator) ~= "function" then
        predicate, iterator, iterand, key = identity, predicate, iterator,
            iterand
    end
    local result = 0
    for _, value in iterator, iterand, key do
        if predicate(value) then
            result = result + 1
        end
    end
    return result
end

local function countfromnext(step, total)
    return step + total, total
end

---Iterate counting from `start`, adding `step` on each iteration.
---@param start number defaults to `1`
---@param step number defaults to `1`
---@return function iterator
function Iterators.countfrom(start, step)
    step = step or 1
    start = start and start - step or 0
    return countfromnext, step, start
end

local function multiply(a, b)
    return a * b
end

---Iterate over the cumulative product of the values of the iterator.
---@param iterator function
---@return function stateful
function Iterators.cumprod(iterator, ...)
    return Iterators.accumulate(multiply, 1, iterator, ...)
end

local function add(a, b)
    return a + b
end

---Iterate over the cumulative sum of the values of the iterator.
---@param iterator function
---@return function stateful
function Iterators.cumsum(iterator, ...)
    return Iterators.accumulate(add, 0, iterator, ...)
end

---Cycle through the values of the iterator forever.
---@param iterator function
---@return function stateful
function Iterators.cycle(iterator, iterand, key)
    local exhausted = false
    local keys = {}
    local values = {}
    local index = 0
    return function()
        if not exhausted then
            local value
            key, value = iterator(iterand, key)
            if key ~= nil then
                table.insert(keys, key)
                table.insert(values, value)
                return value
            end
            exhausted = true
        end
        index = index % #keys + 1
        return keys[index], values[index]
    end
end

---Calculate the differences between each successive value of the iterator.
---@param iterator function
---@return function stateful
function Iterators.diff(iterator, iterand, key)
    local previous
    key, previous = iterator(iterand, key)
    return function()
        local value
        local previouskey = key
        key, value = iterator(iterand, previouskey)
        if not key then
            return
        end
        previous, value = value, value - previous
        return previouskey, value
    end
end

---Drop values from the start of an iterator.
---@param count integer optional, defaults to `1`
---@param iterator function
---@return function iterator
function Iterators.drop(count, iterator, iterand, key)
    if type(count) ~= "number" then
        count, iterator, iterand, key = 1, count, iterator, iterand
    end
    for _ = 1, count do
        key = iterator(iterand, key)
        if key == nil then
            return
        end
    end
    return iterator, iterand, key
end

---Exports all the functions in `Iterators` to globals.
function Iterators.export()
    for key, value in pairs(Iterators) do
        if key ~= "export" then
            _G[key] = value
        end
    end
end

---Calculate the minimum and maximum values of the iterator.
---@param iterator function
---@return any minkey the key of the minimum value
---@return any minvalue the minimum value
---@return any maxkey the key of the maximum value
---@return any maxvalue the maximum value
function Iterators.extrema(iterator, iterand, key)
    local minkey, maxkey, minvalue, maxvalue
    key, minvalue = iterator(iterand, key)
    minkey, maxkey, maxvalue = key, key, minvalue
    if key == nil then
        return
    end
    for k, value in iterator, iterand, key do
        if value < minvalue then
            minkey = k
            minvalue = value
        end
        if value > maxvalue then
            maxkey = k
            maxvalue = value
        end
    end
    return minkey, minvalue, maxkey, maxvalue
end

---Create a list of `value` repeated `count` times.
---@param value any
---@param count integer
---@return table
function Iterators.fill(value, count)
    if not count or count < 0 then
        error "Invalid fill count."
    end
    return Iterators.collect(Iterators.repeated(value, count))
end

---Filter out values which do not satisfy the predicate from the iterator.
---@param predicate function
---@param iterator function
---@return function iterator
function Iterators.filter(predicate, iterator, iterand, key)
    return function()
        local value
        repeat
            key, value = iterator(iterand, key)
        until key == nil or predicate(value)
        return key, value
    end
end

local function fixatenext(endofunctor, init, previous)
    previous = previous or init
    local value = endofunctor(previous)
    if value ~= previous then
        return value, previous
    end
end

---Calls `value = endofunctor(value)`, returning `value` each iteration,
---breaking when a fixed point is found. The iterator returns
---the value and the previous value.
---@param endofunctor function
---@return function iterator
function Iterators.fixate(endofunctor, value)
    return fixatenext, endofunctor, value
end

function Iterators.flatten(...)
    local iterators, outerkey = { ... }, 0
    local innerkey, value, iterator, iterand
    local function flattennext()
        if innerkey == nil then
            outerkey = outerkey + 1
            if outerkey > #iterators then
                return
            end
            iterator, iterand, innerkey = table.unpack(iterators[outerkey])
        end
        innerkey, value = iterator(iterand, innerkey)
        if innerkey == nil then
            return flattennext()
        end
        return innerkey, value
    end
    return flattennext
end

---Call `procedure` on each value of `iterator`, for `procedure`'s side effects.
---@param procedure function
---@param iterator function
---@return nil
function Iterators.foreach(procedure, iterator, ...)
    for _, value in iterator, ... do
        procedure(value)
    end
end

---Call `mapper` on each value of `iterator`.
---@param mapper function
---@param iterator function
---@return function stateful
function Iterators.map(mapper, iterator, iterand, key)
    return function()
        local value
        key, value = iterator(iterand, key)
        if key ~= nil then
            return key, mapper(value)
        end
    end
end

---@param reducer function
---@param mapper function
---@param iterator function
function Iterators.mapreduce(reducer, mapper, iterator, iterand, key)
    local value, other
    key, value = iterator(iterand, key)
    if key ~= nil then
        value = mapper(value)
    end
    while key ~= nil do
        key, other = iterator(iterand, key)
        if key ~= nil then
            value = reducer(value, mapper(other))
        end
    end
    return value
end

---Find the maximum value of an iterator.
---@param iterator function
---@return any maxkey the key of the maximum value
---@return any maxvalue the maximum value
function Iterators.maximum(iterator, ...)
    return select(3, Iterators.extrema(iterator, ...))
end

---Find the minimum value of an iterator.
---@param iterator function
---@return any minkey the key of the minimum value
---@return any minvalue the minimum value
function Iterators.minimum(iterator, ...)
    local minkey, minvalue = Iterators.extrema(iterator, ...)
    return minkey, minvalue
end

---Returns the only value returned by the iterator, or throws an error.
---@param iterator function
function Iterators.only(iterator, iterand, key)
    local value
    key, value = iterator(iterand, key)
    local nextkey = iterator(iterand, key)
    if key and not nextkey then
        return key, value
    else
        error("Expected the iterator to only have one element.")
    end
end

---Partition the keys and values of an iterator into groups with a length
---less than or equal to `count`.
---@param count number
---@param iterator function
---@return function stateful
function Iterators.partition(count, iterator, iterand, key)
    local done = false
    return function()
        if done then
            return
        end
        local keys = {}
        local values = {}
        for _ = 1, count do
            local value
            key, value = iterator(iterand, key)
            if value == nil then
                done = true
                break
            end
            table.insert(keys, key)
            table.insert(values, value)
        end
        if #keys > 0 then
            return keys, values
        end
    end
end

---The product of all values in the iterator.
---@param init any optional, defaults to `1`
---@param iterator function
---@return any product
function Iterators.prod(init, iterator, iterand, key)
    if type(init) == "function" then
        init, iterator, iterand, key = 0, init, iterator, iterand
    end
    for _, value in iterator, iterand, key do
        init = init * value
    end
    return init
end

---Reduce an iterator from the left.
---@param reducer function
---@param iterator function
function Iterators.reduce(reducer, iterator, ...)
    return Iterators.mapreduce(reducer, identity, iterator, ...)
end

local function forevernext(value)
    return value, value
end

local function repeatednext(value, count)
    if count > 0 then
        return count - 1, value
    end
end

---Return `value` `count` times, or forever if no `count` is provided.
---@param count integer optional, defaults to forever
---@return function iterator
function Iterators.repeated(value, count)
    if count == nil then
        return forevernext, value
    elseif count >= 0 then
        return repeatednext, value, count
    else
        error("Can't repeat a value " .. count .. " times.")
    end
end

---Collect all the values of an iterator in reverse order.
---@param iterator function
---@return table collection
function Iterators.reversecollect(iterator, iterand, key)
    local result = {}
    local value
    key, value = iterator(iterand, key)
    while key ~= nil do
        table.insert(result, 1, value)
        key, value = iterator(iterand, key)
    end
    return result
end

local function reverseipairsnext(iterand, index)
    return index - 1, iterand[index - 1]
end

---Iterate over `ipairs(table)` in reverse order.
---@param iterand table
---@return function iterator
---@return table iterand
---@return integer key
function Iterators.reverseipairs(iterand)
    return reverseipairsnext, iterand, #iterand + 1
end

---Sum all the values of the iterator.
---@param init any optional, defaults to `0`
---@param iterator function
---@return any total
function Iterators.sum(init, iterator, iterand, key)
    if type(init) == "function" then
        init, iterator, iterand, key = 0, init, iterator, iterand
    end
    for _, value in iterator, iterand, key do
        init = init + value
    end
    return init
end

---Close over a stateless iterator, converting it to a stateful iterator.
---@param iterator function
---@return function stateful
function Iterators.stateful(iterator, iterand, key)
    return function()
        local value
        key, value = iterator(iterand, key)
        return key, value
    end
end

---Take the first `count` values from `iterator`.
---@param count integer
---@param iterator function
---@return function stateful
function Iterators.take(count, iterator, iterand, key)
    return function()
        count = count - 1
        if count >= 0 then
            return iterator(iterand, key)
        end
    end
end

---Returns the values of the iterator until a value does not fulfill the predicate.
---@param predicate function
---@param iterator function
---@return function stateful
function Iterators.takewhile(predicate, iterator, iterand, key)
    return function()
        local value
        key, value = iterator(iterand, key)
        if predicate(value) then
            return key, value
        end
    end
end

---Iterate over unique values of the given iterator.
---@param iterator function
---@return function stateful
function Iterators.unique(iterator, iterand, key)
    local seen = {}
    return function()
        local value
        repeat
            key, value = iterator(iterand, key)
        until not seen[value] or key == nil
        seen[value] = true
        return key, value
    end
end

local function ziplistsnext(lists, key)
    local values = {}
    key = key + 1
    for index, list in ipairs(lists) do
        local value = list[key]
        if value == nil then
            return
        else
            values[index] = value
        end
    end
    return key, table.unpack(values)
end

---Iterate through several lists together. Each iteration returns an index, and
---the values at that index of each of the lists passed in. Iterates until any of
---the lists is empty.
---@param ... table
---@return function iterator
function Iterators.ziplists(...)
    return ziplistsnext, { ... }, 0
end

return Iterators

local Table = {}

---Deep comparison of two tables.
---@param a table
---@param b table
function Table.equal(a, b)
    local keys = {}
    for key, val in pairs(a) do
        keys[key] = true
        if type(val) == "table" and not Table.equal(val, b[key]) or val ~= b[key] then
            return false
        end
    end
    for key in pairs(b) do
        if keys[key] then
            keys[key] = nil
        else
            return false
        end
    end
    return #keys == 0
end

---Deep comparison of two tables, as lists.
---Only elements with integer indices are compared.
---@param a table
---@param b table
function Table.equallist(a, b)
    if #a ~= #b then
        return false
    end
    for key, val in ipairs(a) do
        if type(val) == "table" and not Table.equal(val, b[key]) or val ~= b[key] then
            return false
        end
    end
    return true
end

---Fills a table with the given value, for all the indices from `start` to `stop`.
---@param list table
---@param value any
---@param start integer? defaults to `1`
---@param stop integer? defaults to `#list`
function Table.fill(list, value, start, stop)
    for i = start or 1, stop or #list do list[i] = value end
    return list
end

---Find the index and value in the list which is equal to the target. If `target`
---is a function, returns the value which matches `target(value)`. `i` and `j` are
---the first and last indices to be searched, defaulting to the whole list. Returns
---`nil` if no match is found.
---@param list table
---@param target any value or predicate
---@param i integer? optional, defaults to `1`
---@param j integer? optional, defaults to `#list`
---@return integer? key
---@return any value
function Table.find(list, target, i, j)
    i = i and (i > 0 and i or #list + i) or 1
    j = j and (j > 0 and j or #list + j) or #list
    if type(target) ~= "function" then
        local t = target
        target = function(x) return x == t end
    end
    for k = i, j do
        local v = list[k]
        if target(v) then
            return k, v
        end
    end
end

---Iterate over each value in the list that matches the target.
---@param list table
---@param target any value or predicate
---@param i integer? optional, defaults to `1`
---@param j integer? optional, defaults to `#list`
---@return function stateful
function Table.findall(list, target, i, j)
    if type(target) ~= "function" then
        local t = target
        target = function(x) return x == t end
    end
    i = i and i - 1 or 0
    return function()
        local v
        i, v = Table.find(list, target, i + 1, j)
        if i then
            return i, v
        end
    end
end

local function lessthan(x)
    return function(y) return y < x end
end

---Find the first and last indices of the range of values which match the target in
---a sorted list.
---@param list table
---@param target any value or predicate
---@param isless function? optional, defaults to `< target`
---@param rev boolean? optional, defaults to `false`
---@param i integer? optional, defaults to `1`
---@param j integer? optional, defaults to `#list`
---@return integer firstindex
---@return integer lastindex
function Table.findsorted(list, target, isless, rev, i, j)
    if type(target) ~= "function" then
        local t = target
        target = function(value) return t == value end
    end
    if type(isless) ~= "function" then
        isless, rev, i, j = lessthan(target), isless, rev, i
    end
    if type(rev) ~= "boolean" then
        rev, i, j = false, rev, i
    end
    i = i or 1
    j = j or #list
    local k, value
    repeat
        if k then
            ---@diagnostic disable-next-line: need-check-nil
            if isless(value) then
                j = k - 1
            else
                i = k + 1
            end
        end
        k = (i + j) // 2
        value = list[k]
    until target(value) or i > j
    if target(value) then
        i = k
        while target(value[i - 1]) do
            i = i - 1
        end
        j = k
        while target(value[j + 1]) do
            j = j + 1
        end
    end
    return i, j
end

local function lt(x, y)
    return x < y
end

---Checks a table is sorted according to operator `isless`.
---@param list table
---@param isless function optional, defaults to `<`
---@param rev boolean optional, defaults to `false`
function Table.issorted(list, isless, rev)
    if type(isless) == "boolean" then
        rev = isless
    end
    if type(isless) ~= "function" then
        isless = lt
    end
    rev = not not rev
    for i = 1, #list - 1 do
        if not isless(list[i], list[i + 1]) == rev then
            return false
        end
    end
    return true
end

return Table

---Find the index and value in the list which is equal to the target. If `target`
---is a function, returns the value which matches `target(value)`. `i` and `j` are
---the first and last indices to be searched, defaulting to the whole list. Returns
---`nil` if no match is found.
---@param list table
---@param target any value or predicate
---@param i integer optional, defaults to `1`
---@param j integer optional, defaults to `#list`
---@return integer|nil key
---@return any value
function table.find(list, target, i, j)
    i = i and (i > 0 and i or #list + i) or 1
    j = j and (j > 0 and j or #list + j) or #list
    target = type(target) == "function" and target or function(x)
        return x == target
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
---@param i integer optional, defaults to `1`
---@param j integer optional, defaults to `#list`
---@return function stateful
function table.findall(list, target, i, j)
    target = type(target) == "function" and target or function(x)
        return x == target
    end
    i = i and i - 1 or 0
    return function()
        local v
        i, v = table.find(list, target, i + 1, j)
        if i then
            return i, v
        end
    end
end

local function islessdefault(a, b)
    return a < b
end

---Checks a table is sorted according to operator `isless`.
---@param list table
---@param isless function optional, defaults to `<`
---@param rev boolean optional, defaults to `false`
---@return boolean
function table.issorted(list, isless, rev)
    if type(isless) == "boolean" then
        rev = isless
    end
    isless = type(isless) == "function" and isless or islessdefault
    rev = rev and true or false
    for i = 1, #list - 1 do
        local b = isless(list[i], list[i + 1])
        if b ~= rev then
            return false
        end
    end
    return true
end

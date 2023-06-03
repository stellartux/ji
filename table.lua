local Table = require("ji/module")("Table")

function Table:copy()
    local result = {}
    for k, v in pairs(self) do
        result[k] = v
    end
    return result
end

---@return any[]
function Table:copyi()
    return table.pack(table.unpack(self))
end

---Deep comparison of two tables.
function Table.equal(self, other)
    if type(self) ~= type(other) then return false end
    if type(self) ~= "table" then return self == other end
    local keys = {}
    for key, val in pairs(self) do
        keys[key] = true
        if not Table.equal(val, other[key]) then
            return false
        end
    end
    for key in pairs(other) do
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
---@param self any[]
---@param other any[]
function Table.equali(self, other)
    if type(self) ~= "table" or type(other) ~= "table" or #self ~= #other then
        return false
    end
    for key, val in ipairs(self) do
        if not Table.equal(val, other[key]) then
            return false
        end
    end
    return true
end

Table.equallist = Table.equali

---Fills a table with the given value, for all the indices from `start` to `stop`.
---@param list table
---@param value any
---@param start integer? defaults to `1`
---@param stop integer? defaults to `#list`
function Table.fill(list, value, start, stop)
    for i = start or 1, stop or #list do list[i] = value end
    return list
end

--- Find the index and value in the list which is equal to the target. If
--- `target` is a function, returns the value which matches `target(value)`. `i`
--- and `j` are the first and last indices to be searched, defaulting to the
--- whole list. Returns `nil` if no match is found.
---@generic T
---@param list T[]
---@param target T|fun(t:T):any value or predicate
---@param i integer? optional, defaults to `1`
---@param j integer? optional, defaults to `#list`
---@return integer key
---@return T value
---@overload fun(list: any[], target: any, i?: integer, j?: integer): nil
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
---@generic T
---@param list T[]
---@param target T|(fun(t:T):any) value or predicate
---@param i integer? optional, defaults to `1`
---@param j integer? optional, defaults to `#list`
---@return fun(): (integer?, T?) stateful
function Table.findall(list, target, i, j)
    if type(target) ~= "function" then
        local t = target
        target = function(x) return x == t end
    end
    i = i and i - 1 or 0
    return function()
        local v
        i, v = Table.find(list, target, i + 1, j)
        return i, v
    end
end

local function lessthan(x)
    return function(y) return y < x end
end

---Find the first and last indices of the range of values which match the target in
---a sorted list.
---@generic T
---@param list T[]
---@param target T|fun(t:T):any value or predicate
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
        isless, rev, i, j = lessthan(target), isless --[[@as boolean]], rev --[[@as integer]], i
    end
    if type(rev) ~= "boolean" then
        rev, i, j = false, rev --[[@as integer]], i
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
---@param list any[]
---@param isless fun(l, r): boolean optional, defaults to `<`
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

function Table.map(self, fn)
    local result = {}
    for key, value in ipairs(self) do
        result[key] = fn(value, key, self)
    end
    return result
end

---Print the table as a hashmap.
---@param self table
function Table.print(self)
    for k, v in pairs(self) do print(k, v) end
end

---Print the table as a list.
---@param self any[]
function Table.printi(self)
    for i, v in ipairs(self) do print(i, v) end
end

---Reverses a list in place.
---@param self any[]
---@param start integer? defaults to `1`
---@param stop integer? defaults to `#list`
---@return any[] self modified input list
function Table.reverse(self, start, stop)
    start = start and assert(start >= 1 and math.tointeger(start),
        "start must be between 1 and the length of the list.") or 1
    stop = stop and assert(stop <= #self and math.tointeger(stop),
        "stop must be between 1 and the length of the list.") or #self
    for i = 0, (stop - start) // 2 do
        self[start + i], self[stop - i] = self[stop - i], self[start + i]
    end
    return self
end

local function repr(value)
    if type(value) == "string" then
        return "\"" .. value:gsub("[\"\\]", "\\%0") .. "\""
    else
        return tostring(value)
    end
end

---@param self table
function Table.show(self)
    print((self.__name or "") .. " {")
    for key, val in pairs(self) do
        print("    "
            .. (type(key) == "number" and "[" .. key .. "]" or tostring(key))
            .. " = "
            .. (val == self and "self" or repr(val))
            .. (next(self, key) and "," or ""))
    end
    print("}")
end

---@param self table
function Table.showi(self)
    ---@diagnostic disable-next-line: undefined-field
    print((self.__name or "") .. " { "
        .. table.concat(Table.map(self, repr), ", ")
        .. " }")
end

return Table

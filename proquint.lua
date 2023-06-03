--- Proquints: PROnouncable QUINTuplets
--- see https://arxiv.org/html/0901.4016
local Proquint = { __name = "Proquint" }

local consonants = {
    [0] = 'b', 'd', 'f', 'g',
    'h', 'j', 'k', 'l',
    'm', 'n', 'p', 'r',
    's', 't', 'v', 'z',
    b = 0, d = 1, f = 2, g = 3,
    h = 4, j = 5, k = 6, l = 7,
    m = 8, n = 9, p = 10, r = 11,
    s = 12, t = 13, v = 14, z = 15,
}

local vowels = {
    [0] = 'a', 'i', 'o', 'u',
    a = 0, i = 1, o = 2, u = 3
}

--- Map a quint to an integer, skipping non-coding characters.
---@param quint string
---@return integer
function Proquint.tonumber(quint)
    local result = 0
    for m in quint:gmatch("[aioubdfghjklmnprstvz]") do
        if vowels[m] then
            result = (result << 2) + vowels[m]
        else
            result = (result << 4) + consonants[m]
        end
    end
    return result
end

--- Map an integer to one to four quints, using `sepchar` to separate them.
---@param n integer
---@param sepchar string? optional separation character, defaults to `"-"`
function Proquint.toquint(n, sepchar)
    local result = {}
    while n > 0 do
        table.insert(result, 1,
            consonants[0xf & n >> 12] ..
            vowels[0x3 & n >> 10] ..
            consonants[0xf & n >> 6] ..
            vowels[0x3 & n >> 4] ..
            consonants[0xf & n]
        )
        n = n >> 16
    end
    return table.concat(result, sepchar or "-")
end

if pcall(debug.getlocal, 4, 1) then
    return Proquint
else
    if (...):match("^%d+$") then
        print(Proquint.toquint(tonumber(...) --[[@as number]]))
    else
        print(Proquint.tonumber(...))
    end
end

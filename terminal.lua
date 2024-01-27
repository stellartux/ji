---@alias uint8 integer

---@class Terminal
---@field write fun(self: Terminal, ...): self
---@field close fun(self: Terminal, ...): nil close the terminal before program exit to ensure it returns to the original state
---@field columns integer
---@field lines integer
local Terminal = setmetatable({
    __name = "Terminal",
    Black = 0,
    Red = 1,
    Green = 2,
    Yellow = 3,
    Blue = 4,
    Magenta = 5,
    Cyan = 6,
    White = 7,
    BrightBlack = 8,
    BrightRed = 9,
    BrightGreen = 10,
    BrightYellow = 11,
    BrightBlue = 12,
    BrightMagenta = 13,
    BrightCyan = 14,
    BrightWhite = 15
}, {
    ---@param self Terminal
    ---@param file file*|{ write: function, close: function? }? defaults to stdout
    ---@return Terminal
    __call = function(self, file)
        file = file or io.stdout
        file:write("\27[?1049h")
        return setmetatable({
            write = function(self, ...)
                file:write(...)
                return self
            end,
            close = function(self)
                if not file then return end
                self:showcursor()
                local f = file --[[@as file*]]
                file = nil
                f:write("\27[?1049l\27[0m\n")
                if f ~= io.stdout then f:close() end
            end
        }, self)
    end
})

function Terminal:__close()
    self:close()
end

function Terminal:__index(key)
    if key == "columns" then
        return math.tointeger(os.getenv("COLUMNS")) or 80
    elseif key == "lines" then
        return math.tointeger(os.getenv("LINES")) or 24
    else
        return Terminal[key]
    end
end

---@param x integer
---@param y integer
function Terminal:position(x, y) return self:write("\27[", x, ";", y, "H") end

---@param r uint8 red 0-255
---@param g uint8 green 0-255
---@param b uint8 blue 0-255
---@return self
---@overload fun(self: Terminal, color: uint8): Terminal
function Terminal:bgcolor(r, g, b)
    if g and b then
        return self:write("\27[48;2;", r, ";", g, ";", b, "m")
    else
        return self:write("\27[48;5;", r, "m")
    end
end

---@param r uint8 red 0-255
---@param g uint8 green 0-255
---@param b uint8 blue 0-255
---@return self
---@overload fun(self: Terminal, color: uint8): Terminal
function Terminal:color(r, g, b)
    if g and b then
        return self:write("\27[38;2;", r, ";", g, ";", b, "m")
    else
        return self:write("\27[38;5;", r, "m")
    end
end

function Terminal:clearscreen() return self:write("\27[2J") end

---@param text string
---@param width integer
function Terminal:writewrapped(text, width)
    local words = text:gmatch("%S+")
    local word = words()
    self:write(word)
    local x = #word
    for word in words do
        if x + #word + 1 >= width then
            self:back(x):down(1):write(word)
            x = #word
        else
            self:write(" ", word)
            x = x + #word + 1
        end
    end
    return self
end

---@param width integer
---@param height integer
---@return Terminal
function Terminal:drawbox(width, height)
    if width < 2 or height < 2 then return self end
    self:write("╔", ("═"):rep(width - 2), "╗")
    for _ = 2, height - 1 do
        self:back(width):down(1):write("║"):forward(width - 2):write("║")
    end
    return self:back(width):down(1):write("╚", ("═"):rep(width - 2), "╝")
end

---@param char string
---@param width integer defaults to columns
---@param height integer defaults to lines
function Terminal:fillarea(char, width, height)
    width = width or self.columns
    height = height or self.lines
    local line = char:rep(width)
    if height >= 1 then
        self:write(line)
    end
    for _ = 2, height do
        self:back(width):down(1):write(line)
    end
    return self
end

function Terminal:hidecursor() return self:write("\27[?25l") end

function Terminal:showcursor() return self:write("\27[?25h") end

function Terminal:savecursor() return self:write("\27[s") end

function Terminal:restorecursor() return self:write("\27[u") end

---@param n integer?
function Terminal:up(n) return self:write("\27[", n or "", "A") end

---@param n integer?
function Terminal:down(n) return self:write("\27[", n or "", "B") end

---@param n integer?
function Terminal:forward(n) return self:write("\27[", n or "", "C") end

---@param n integer?
function Terminal:back(n) return self:write("\27[", n or "", "D") end

return Terminal

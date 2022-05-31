local ji = {
    Class = require("ji/class"),
    Deque = require("ji/deque"),
    Iterators = require("ji/iterators"),
    Lens = require("ji/lens"),
    Math = require("ji/math"),
    Object = require("ji/object"),
    Set = require("ji/set"),
    String = require("ji/string"),
    Table = require("ji/table"),
}

function ji:export(scope)
    local s = scope or _G
    s.Class = ji.Class
    s.Deque = ji.Deque
    ji.Iterators:export(s)
    s.Lens = ji.Lens
    ji.Math:export(scope or math)
    s.Object = ji.Object
    s.Set = ji.Set
    ji.String:export(scope or string)
    ji.Table:export(scope or table)
end

return ji

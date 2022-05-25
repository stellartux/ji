local Deque = require "ji/deque"

local deque = Deque:new()

assert(#deque == 0, "New Deque should have length 0.")
deque:push(42)
assert(#deque == 1, "Deque should have length 1.")
assert(deque:pop() == 42, "Deque should be able to pop.")

local other = Deque()
assert(deque == other, "Empty deques should be equal.")

deque:push(13)
deque:push(14)
assert(#deque == 2, "Deque should have length 2.")
assert(deque:pop() == 14, "Deque should be able to pop items in order.")
assert(deque:pop() == 13, "Deque should be able to pop items in order.")

deque:push(1)
other:push(1)
assert(deque == other, "Non-empty deques should be equal.")

other:push(2)
assert(deque ~= other,
    "Different length deques with equal values in the overlapping region should not be equal.")
deque:push(3)
assert(deque ~= other,
    "Matching length deques with different elements should not be equal.")

deque:empty()
assert(#deque == 0, "Emptied deque should have length 0.")

deque:push(15)
deque:push(16)
deque:push(17)
deque:pushfirst(14)
deque:pushfirst(13)
assert(#deque == 5, "Deque should have length 5.")
assert(deque:popfirst() == 13, "Deque should be able to pop items in order.")
assert(deque:pop() == 17, "Deque should be able to pop items in order.")
assert(deque:pop() == 16, "Deque should be able to pop items in order.")
assert(deque:popfirst() == 14, "Deque should be able to pop items in order.")
assert(deque:popfirst() == 15, "Deque should be able to pop items in order.")

deque:push(1)
deque:push(2)
deque:push(3)
deque:push(4)
assert(table.concat(deque, ",") == "1,2,3,4",
    "Should be able to table.concat a deque.")
deque:reverse()
assert(deque == Deque { 4, 3, 2, 1 }, "Should be able to reverse a deque.")
deque:pushfirst(5)
deque:reverse()
assert(deque == Deque { 1, 2, 3, 4, 5 },
    "Should be able to reverse a deque with low firstindex.")

other = Deque { 1, 2, 3, 4, 5 }
assert(other == deque, "Should be able to construct a deque from a list.")

deque:append(Deque { 6, 7, 8, 9, 10 })
assert(#deque == 10, "Deque should have length 10.")
assert(deque == Deque { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
    "Should be able to append to the end of deque.")

other = Deque { -4, -3, -2, -1, 0 }
deque:prepend(other)
assert(deque == Deque { -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
    "Should be able to prepend to the start of a deque.")

print("deque.lua - Tests passed.")

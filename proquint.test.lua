local Proquint = require("proquint")

local testcases = {
    ["lusab-babad"] = 2130706433,
    ["gutih-tugad"] = 1062526145,
    ["gutuk-bisog"] = 1064699683,
    ["mudof-sakat"] = 2355282317,
    ["haguz-biram"] = 1090455240,
    ["mabiv-gibot"] = 2149463085,
    ["natag-lisaf"] = 2470672130,
    ["tibup-zujah"] = 3560635716,
    ["tobog-higil"] = 3626190039,
    ["todah-vobij"] = 3628394517,
    ["sinid-makam"] = 3327230344,
    ["budov-kuras"] = 208563916
}

local function test(fn, input, expected)
    local actual = fn(input)
    if actual ~= expected then
        error("Test failed: for f(\"" .. input .. "\") got " .. actual .. ", but expected " .. expected)
    end
end

for str, num in pairs(testcases) do
    test(Proquint.tostring, num, str)
    test(Proquint.tonumber, str, num)
end

print("Proquint: all tests passed!")

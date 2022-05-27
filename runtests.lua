print("\
        _______  __\
       /____  / / /\
           / / / /\
      __  / / / /\
     / /_/ / / /\
    /_____/ /_/\
\
    TEST SUITE\
")

local function iswindows()
    return string.sub(package.config, 1, 1) == "\\"
end

for filename in io.popen(iswindows() and "dir /B" or "ls -R -1"):lines() do
    if filename:match("test%.lua$") then dofile(filename) end
end

print("\nAll tests completed.")

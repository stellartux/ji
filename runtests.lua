print("Running test suite.")
for filename in io.popen("dir /B"):lines() do
    if filename:match("test%.lua$") then
        dofile(filename)
    end
end
print("All tests completed.")

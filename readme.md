# ji.lua

Ji.lua is a collection of Lua implementations of functional primitives that work
on iterators, based on features from the Julia
[Base.Iterators](https://docs.julialang.org/en/v1/base/iterators/) library, and
a few other data structures that make Lua a little less minimalistic.

## Features

### `Iterators`

Most of the functionality of Julia's Base.Iterators, adapted to Lua's iterator
protocol.

### Types

- `Class`
  - OOP boilerplate, used by all the other types
- `Deque`
  - tables as stacks, queues or double-ended queues
- `Lens`
  - bijective tables, where mapping a key to a value also maps the value to the
    key.
- `Object`
  - tables that can be frozen or sealed like JavaScript objects
- `Set`
  - tables with set-like operations

Examples of how to use each of the types can be found in their test files.

### `string`

More string manipulation functions added to the `string` prototype.

- `chomp`
  - Removes a trailing new line, if any.
- `endswith`, `startswith`
  - Check for patterns at the start or end of a string.
- `gsplit`, `split`
  - Split a string with a pattern, returning an iterator or a list of strings.
- `isascii`
  - Checks if all characters of a string are in the lower ASCII range.
- `lpad`, `rpad`
  - Pad the start or end of a string to a specified length.
- `lstrip`, `rstrip`, `strip`
  - Strip characters from a string at the start, the end or both.

### `table`

- `find`
  - Finds the index of a value in a list.
- `findall`
  - Iterate over all matching values in a list.
- `issorted`
  - Check if a list is sorted.

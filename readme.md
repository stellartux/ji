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

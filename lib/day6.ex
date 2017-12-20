#------------------------------------------------------------------------------
# Day Six
#------------------------------------------------------------------------------

defmodule AdventOfCode2017.Day6 do
  @input "data/day6.input"
    |> File.read!
    |> String.split
    |> Enum.map(&String.to_integer/1)

  def input, do: @input
end

#------------------------------------------------------------------------------
# Part One
#
# In this area, there are sixteen memory banks; each memory bank can hold any
# number of blocks. The goal of the reallocation routine is to balance the
# blocks between the memory banks.
#
# The reallocation routine operates in cycles. In each cycle, it finds the
# memory bank with the most blocks (ties won by the lowest-numbered memory
# bank) and redistributes those blocks among the banks. To do this, it removes
# all of the blocks from the selected bank, then moves to the next (by index)
# memory bank and inserts one of the blocks. It continues doing this until it
# runs out of blocks; if it reaches the last memory bank, it wraps around to
# the first one.
#
# Given the initial block counts in your puzzle input, how many redistribution
# cycles must be completed before a configuration is produced that has been
# seen before?
#------------------------------------------------------------------------------

defmodule AdventOfCode2017.Day6.Part1 do
  import AdventOfCode2017.Day6

  def solve_puzzle,
    do: input() |> build_map |> count_cycles

  def count_cycles(mem),
    do: count_cycles(mem, MapSet.new(), 0)
  def count_cycles(mem, cycles, n) do
    if not found?(cycles, mem) do
      cycles = store_cycle(cycles, mem)
      mem |> redistribute_highest |> count_cycles(cycles, n + 1)
    else
      n
    end
  end

  def found?(cycles, mem),
    do: MapSet.member?(cycles, hash(mem))

  def store_cycle(cycles, mem),
    do: MapSet.put(cycles, hash(mem))

  def hash(mem),
    do: :crypto.hash(:sha256, Map.values(mem))

  def build_map(input),
    do: 0..length(input) |> Enum.zip(input) |> Map.new

  def redistribute_highest(mem) do
    {i, value} = find_highest(mem)
    mem |> Map.put(i, 0) |> redistribute(i + 1, value)
  end

  def find_highest(mem),
    do: mem |> Map.to_list |> Enum.reduce(nil, &find_highest_reducer/2)

  def find_highest_reducer(cell, nil),
    do: cell
  def find_highest_reducer({i, v}, {_j, high}) when v > high,
    do: {i, v}
  def find_highest_reducer(_cell, acc),
    do: acc

  def redistribute(mem, _start, 0),
    do: mem
  def redistribute(mem, start, value) do
    if start >= mem |> Map.keys |> length do
      redistribute(mem, 0, value)
    else
      mem |> Map.update!(start, &(&1 + 1)) |> redistribute(start + 1, value - 1)
    end
  end

end

#------------------------------------------------------------------------------
# Part Two
#
# Out of curiosity, the debugger would also like to know the size of the loop:
# starting from a state that has already been seen, how many block
# redistribution cycles must be performed before that same state is seen again?
#------------------------------------------------------------------------------

defmodule AdventOfCode2017.Day6.Part2 do
  import AdventOfCode2017.Day6

  def solve_puzzle,
    do: input() |> build_map |> count_cycles

  def count_cycles(mem),
    do: count_cycles(mem, Map.new(), 0)
  def count_cycles(mem, cycles, n) do
    if not found?(cycles, mem) do
      cycles = cycles |> increment_all_cycles |> store_cycle(mem)
      mem |> redistribute_highest |> count_cycles(cycles, n + 1)
    else
      get_loop_count(cycles, mem)
    end
  end

  def found?(cycles, mem),
    do: Map.has_key?(cycles, hash(mem))

  def store_cycle(cycles, mem),
    do: Map.put(cycles, hash(mem), 1)

  def get_loop_count(cycles, mem),
    do: Map.get(cycles, hash(mem))

  def hash(mem) do
    :crypto.hash(:sha256, Map.values(mem))
  end

  def increment_all_cycles(cycles),
    do: Map.new(cycles, fn {k, v} -> {k, v + 1} end)

  def build_map(input),
    do: 0..length(input) |> Enum.zip(input) |> Map.new

  def redistribute_highest(mem) do
    {i, value} = find_highest(mem)
    mem |> Map.put(i, 0) |> redistribute(i + 1, value)
  end

  def find_highest(mem),
    do: mem |> Map.to_list |> Enum.reduce(nil, &find_highest_reducer/2)

  def find_highest_reducer(cell, nil),
    do: cell
  def find_highest_reducer({i, v}, {_j, high}) when v > high,
    do: {i, v}
  def find_highest_reducer(_cell, acc),
    do: acc

  def redistribute(mem, _start, 0),
    do: mem
  def redistribute(mem, start, value) do
    if start >= mem |> Map.keys |> length do
      redistribute(mem, 0, value)
    else
      mem |> Map.update!(start, &(&1 + 1)) |> redistribute(start + 1, value - 1)
    end
  end

end

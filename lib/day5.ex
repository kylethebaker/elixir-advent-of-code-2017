#------------------------------------------------------------------------------
# Day Five
#------------------------------------------------------------------------------

defmodule AdventOfCode2017.Day5 do
  @input "data/day5.input"
    |> File.read!
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)

  def input, do: @input

  def find_steps_til_exit(steps, jump_fn),
    do: steps |> create_steps_map |> find_steps_til_exit(0, 0, jump_fn)

  def find_steps_til_exit(steps, current, taken, jump_fn) do
    if is_outside?(steps, current) do
      taken
    else
      {to_take, new_steps} = jump(steps, current, jump_fn)
      find_steps_til_exit(new_steps, current + to_take, taken + 1, jump_fn)
    end
  end

  def is_outside?(steps, step),
    do: not Map.has_key?(steps, step)

  def jump(steps, current, jump_fn),
    do: Map.get_and_update(steps, current, jump_fn)

  def create_steps_map(steps),
    do: 0..length(steps) |> Enum.to_list |> Enum.zip(steps) |> Map.new
end

#------------------------------------------------------------------------------
# Part One
#
# The input includes a list of offsets for each jump. Jumps are relative: -1
# moves to the previous instruction, and 2 skips the next one. Start at the
# first instruction in the list. The goal is to follow the jumps until one
# leads outside the list.
#
# In addition, these instructions are a little strange; after each jump, the
# offset of that instruction increases by 1. So, if you come across an offset
# of 3, you would move three instructions forward, but change it to a 4 for the
# next time it is encountered.
#
# How many steps does it take to reach the exit?
#------------------------------------------------------------------------------

defmodule AdventOfCode2017.Day5.Part1 do
  import AdventOfCode2017.Day5

  def solve_puzzle,
    do: input() |> find_steps_til_exit(&jump_fn/1)

  def jump_fn(x),
    do: {x , x + 1}
end

#------------------------------------------------------------------------------
# Part Two
#
# Same as Part1 except rather than increasing the instruction by 1 after each
# jump instead do: if the the instruction is greater than or equal to 3
# decrease by one, else increase by 1
#------------------------------------------------------------------------------

defmodule AdventOfCode2017.Day5.Part2 do
  import AdventOfCode2017.Day5

  def solve_puzzle,
    do: input() |> find_steps_til_exit(&jump_fn/1)

  def jump_fn(x) when x >= 3,
    do: {x , x - 1}
  def jump_fn(x),
    do: {x , x + 1}
end

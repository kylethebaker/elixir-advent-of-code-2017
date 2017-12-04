#------------------------------------------------------------------------------
# Day Two
#------------------------------------------------------------------------------

defmodule AdventOfCode2017.Day2 do
  @input "data/day2.input"

  def input,
    do: for line <- @input |> File.read! |> String.split("\n", trim: true),
      do: for x <- String.split(line, "\t"),
        do: String.to_integer(x)

end

#------------------------------------------------------------------------------
# Part One
#------------------------------------------------------------------------------

defmodule AdventOfCode2017.Day2.Part1 do
  import AdventOfCode2017.Day2

  def solve_puzzle,
    do: input() |> solve_checksum

  def solve_checksum(input),
    do: input |> Enum.map(&row_checksum/1) |> Enum.sum

  def row_checksum(row),
    do: row |> find_low_and_high |> difference

  defp find_low_and_high(list),
    do: Enum.reduce(list, {nil, nil}, &low_high_reducer/2)

  defp low_high_reducer(x, {nil, nil}),
    do: {x, x}
  defp low_high_reducer(x, {low, high}) when x < low,
    do: {x, high}
  defp low_high_reducer(x, {low, high}) when x > high,
    do: {low, x}
  defp low_high_reducer(_x, acc),
    do: acc

  defp difference({low, high}),
    do: high - low

end

#------------------------------------------------------------------------------
# Part Two
#------------------------------------------------------------------------------

defmodule AdventOfCode2017.Day2.Part2 do
  import AdventOfCode2017.Day2

  def solve_puzzle,
    do: input() |> solve_checksum

  def solve_checksum(input),
    do: input |> Enum.map(&row_checksum/1) |> Enum.sum

  def row_checksum(row),
    do: row |> find_evenly_divisible |> hd |> divide_tuple

  defp find_evenly_divisible(list),
    do: for x <- list, y <- list, x > y, rem(x, y) === 0,
      do: {x, y}

  defp divide_tuple({x, y}), do: div(x, y)

end

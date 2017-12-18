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
#
# Given a table of data, find the checksum. The checksum is calculated by
# summing the difference between the highest and lowest cell of each row.
#
# For example, given the following spreadsheet:
#
#  5 1 9 5
#  7 5 3
#  2 4 6 8
#
#  - The first row's largest and smallest values are 9 and 1, and their
#    difference is 8
#
#  - The second row's largest and smallest values are 7 and 3, and their
#    difference is 4
#
#  - The third row's difference is 6
#
# In this example, the spreadsheet's checksum would be 8 + 4 + 6 = 18
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
#
# Find the only two numbers in each row where one evenly divides the other -
# that is, where the result of the division operation is a whole number. Find
# those numbers on each line, divide them, and add up each line's result.
#
# For example, given the following spreadsheet:
#
#  5 9 2 8
#  9 4 7 3
#  3 8 6 5
#
#  - In the first row, the only two numbers that evenly divide are 8 and 2; the
#    result of this division is 4
#
#  - In the second row, the two numbers are 9 and 3; the result is 3
#
#  - In the third row, the result is 2
#
# In this example, the sum of the results (checksum) would be 4 + 3 + 2 = 9
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

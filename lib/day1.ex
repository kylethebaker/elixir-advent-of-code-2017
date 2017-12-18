#------------------------------------------------------------------------------
# Day One
#------------------------------------------------------------------------------

defmodule AdventOfCode2017.Day1 do
  @input "data/day1.input"
    |> File.read!
    |> String.trim
    |> String.graphemes
    |> Enum.map(&String.to_integer/1)

  def input, do: @input
end

#------------------------------------------------------------------------------
# Part One
#
# Solve a captcha in the form 11888833299911 where the solution in the sum of
# of all digits that match the next digit in the sequence. The list is
# circular, in that the last digit is the first digit in the sequence.
#
# Examples:
#
#  - 1122 produces a sum of 3 (1 + 2) because the first digit (1) matches the
#    second digit and the third digit (2) matches the fourth digit.
#
#  - 1111 produces 4 because each digit (all 1) matches the next.
#
#  - 1234 produces 0 because no digit matches the next.
#
#  - 91212129 produces 9 because the only digit that matches the next one is
#    the last digit, 9.
#------------------------------------------------------------------------------

defmodule AdventOfCode2017.Day1.Part1 do
  import AdventOfCode2017.Day1

  def solve_puzzle,
    do: input() |> solve_captcha

  def solve_captcha(captcha) do
    captcha
    |> move_last_to_first
    |> Enum.reduce({0, nil}, &reducer/2)
    |> elem(0)
  end

  defp move_last_to_first(captcha),
    do: [captcha |> Enum.reverse |> hd | captcha]

  defp reducer(current, {sum, nil}),
    do: {sum, current}
  defp reducer(last, {sum, last}),
    do: {sum + last, last}
  defp reducer(current, {sum, _last}),
    do: {sum, current}

end

#------------------------------------------------------------------------------
# Part Two
#
# Now, instead of considering the next digit, it wants you to consider the
# digit halfway around the circular list. That is, if your list contains 10
# items, only include a digit in your sum if the digit 10/2 = 5 steps forward
# matches it. Fortunately, your list has an even number of elements.
#
# Examples:
#
#  - 1212 produces 6: the list contains 4 items, and all four digits match the
#    digit 2 items ahead.
#
#  - 1221 produces 0, because every comparison is between a 1 and a 2.
#
#  - 123425 produces 4, because both 2s match each other, but no other digit
#    has a match.
#
#  - 123123 produces 12.
#
#  - 12131415 produces 4.
#
#------------------------------------------------------------------------------

defmodule AdventOfCode2017.Day1.Part2 do
  import AdventOfCode2017.Day1

  def solve_puzzle,
    do: input() |> solve_captcha

  def solve_captcha(captcha) do
    captcha
    |> Enum.split(round(length(captcha) / 2))
    |> Tuple.to_list
    |> Enum.zip
    |> Enum.reduce(0, &reducer/2)
  end

  defp reducer({x, x}, sum),
    do: sum + x + x
  defp reducer({_x, _y}, sum),
    do: sum

end

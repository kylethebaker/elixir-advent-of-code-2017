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

#------------------------------------------------------------------------------
# Day Seven
#------------------------------------------------------------------------------

defmodule AdventOfCode2017.Day7 do
  @input "data/day7.input"
    |> File.read!
    |> String.split("\n", trim: true)

  def input,
    do: @input |> Enum.map(&parse_disc_str/1)

  def parse_disc_str(disc_str),
    do: disc_str |> String.split("->", trim: true) |> parse_disc

  def parse_disc([key_str]) do
    {key, weight} = parse_key(key_str)
    {key, weight, []}
  end

  def parse_disc([key_str, child_str]) do
    {key, weight} = parse_key(key_str)
    {key, weight, parse_children(child_str)}
  end

  def parse_key(key_str) do
    [key, weight_str] = String.split(key_str, " ", trim: true)
    weight = weight_str |> strip_parens |> String.to_integer
    {String.to_atom(key), weight}
  end

  def strip_parens(weight_str),
    do: weight_str |> String.trim_leading("(") |> String.trim_trailing(")")

  def parse_children(child_str) do
    child_str
    |> String.split(", ", trim: true)
    |> Enum.map(fn x ->
      x |> String.trim |> String.to_atom
    end)
  end

end

#------------------------------------------------------------------------------
# Part One
#------------------------------------------------------------------------------

defmodule AdventOfCode2017.Day7.Part1 do
  import AdventOfCode2017.Day7

  def solve_puzzle,
    do: input()
end

#------------------------------------------------------------------------------
# Part Two
#------------------------------------------------------------------------------

defmodule AdventOfCode2017.Day7.Part2 do
  import AdventOfCode2017.Day7

  def solve_puzzle,
    do: input()
end

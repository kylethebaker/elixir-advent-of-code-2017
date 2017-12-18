#------------------------------------------------------------------------------
# Day Three
#------------------------------------------------------------------------------

defmodule AdventOfCode2017.Day3 do
  @input "data/day3.input"

  def input,
    do: @input |> File.read! |> String.trim |> String.to_integer
end

#------------------------------------------------------------------------------
# Part One
#
# Each square on the grid is allocated in a spiral pattern starting at a
# location marked 1 and then counting up while spiraling outward. For example,
# the first few squares are allocated like this:
#
#   17  16  15  14  13 .
#   18   5   4   3  12 .
#   19   6   1   2  11 .
#   20   7   8   9  10 .
#   21  22  23  24  25 26
#
# Given a number on the grid, find the manhattan distance to the center.
#------------------------------------------------------------------------------

defmodule AdventOfCode2017.Day3.Part1 do
  import AdventOfCode2017.Day3
  alias :math, as: Math

  def solve do
    cell = input()
    ring = find_ring(cell)
    ring_size = ring_size(ring)
    ring_start = ring_start(ring_size)
    ring_mid = ring_mid(ring_size)
    distance_to_corner = distance_to_corner(cell, ring_start, ring_size)
    ring_mid + abs(distance_to_corner - ring_mid)
  end

  # Which ring does a cell fall in
  def find_ring(n) do
    Stream.iterate(1, &(&1 + 2))
    |> Stream.map(&(&1 * &1))
    |> Stream.take_while(&(&1 < n))
    |> Enum.to_list
    |> length
  end

  # How many cells in one side of a ring
  def ring_size(ring),
    do: (ring * 2) + 1

  # What the is the highest cell in the previous ring
  def ring_start(ring_size),
    do: Math.pow(ring_size - 2, 2) |> trunc

  # How close is a cell to a rings corner
  def distance_to_corner(n, ring_start, ring_size),
    do: rem(n - ring_start, ring_size - 1)

  # What is the center of a rings side
  def ring_mid(ring_size),
    do: div(ring_size, 2)

end

#------------------------------------------------------------------------------
# Part Two
#
# As a stress test on the system, the programs here clear the grid and then
# store the value 1 in square 1. Then, in the same allocation order as shown
# above, they store the sum of the values in all adjacent squares, including
# diagonals.
#
#   147  142  133  122   59
#   304    5    4    2   57
#   330   10    1    1   54
#   351   11   23   25   26
#   362  747  806--->   ...
#
# Once a square is written, its value does not change. Therefore, the first few
# squares would receive the following values:
#
# What is the first value written that is larger than your puzzle input?
#------------------------------------------------------------------------------

defmodule AdventOfCode2017.Day3.Part2 do
  import AdventOfCode2017.Day3
  alias AdventOfCode2017.Day3.Part2.Spiral

  def solve do
    Spiral.new
    |> Stream.iterate(&Spiral.next(&1))
    |> Stream.drop_while(&(Spiral.current_value(&1) < input()))
    |> Enum.take(1)
    |> hd
    |> Spiral.current_value
  end

end

defmodule AdventOfCode2017.Day3.Part2.Spiral do
  @directions [:left, :right, :up, :down, :up_left, :up_right, :down_left, :down_right]

  defstruct [:coords, :current, :direction]

  def new,
    do: new(%{{0, 0} => 1}, :right, {0, 0})

  def new(coords, direction, current),
    do: %__MODULE__{coords: coords, direction: direction, current: current}

  def current_value(spiral),
    do: Map.get(spiral.coords, spiral.current)

  def next(spiral) do
    next_coord = adjacent_coord(spiral.current, spiral.direction)
    next_value = Enum.sum(adjacent_values(spiral.coords, next_coord))
    updated_coords = Map.put(spiral.coords, next_coord, next_value)
    next_direction = next_direction(spiral.direction, next_coord)
    new(updated_coords, next_direction, next_coord)
  end

  def adjacent_values(coords, coord) do
    reducer = fn (dir, values) ->
      adjacent = adjacent_coord(coord, dir)
      [Map.get(coords, adjacent) | values]
    end

    @directions
    |> Enum.reduce([], reducer)
    |> Enum.filter(&(&1 !== nil))
  end

  def adjacent_coord({x, y}, :left), do: {x - 1, y}
  def adjacent_coord({x, y}, :right), do: {x + 1, y}
  def adjacent_coord({x, y}, :up), do: {x, y + 1}
  def adjacent_coord({x, y}, :down), do: {x, y - 1}
  def adjacent_coord({x, y}, :up_left), do: {x - 1, y + 1}
  def adjacent_coord({x, y}, :up_right), do: {x + 1, y + 1}
  def adjacent_coord({x, y}, :down_left), do: {x - 1, y - 1}
  def adjacent_coord({x, y}, :down_right), do: {x + 1, y - 1}

  def next_direction(direction, coord) do
    if should_turn?(coord) do
      turn(direction)
    else
      direction
    end
  end

  def should_turn?({x, y}) do
    Enum.any?([
      x > 0 && y <= 0 && x - abs(y) === 1,
      x > 0 && y > 0 && x === y,
      x < 0 && abs(x) === abs(y),
    ])
  end

  def turn(:right), do: :up
  def turn(:up), do: :left
  def turn(:left), do: :down
  def turn(:down), do: :right
end

#------------------------------------------------------------------------------
# Day Four
#------------------------------------------------------------------------------

defmodule AdventOfCode2017.Day4 do
  @input "data/day4.input"
    |> File.read!
    |> String.split("\n", trim: true)

  def input, do: @input
end

#------------------------------------------------------------------------------
# Part One
#
# A new system policy has been put in place that requires all accounts to
# use a passphrase instead of simply a password. A passphrase consists of
# a series of words (lowercase letters) separated by spaces.
#
# To ensure security, a valid passphrase must contain no duplicate words.
#
# How many passphrases are valid?
#------------------------------------------------------------------------------

defmodule AdventOfCode2017.Day4.Part1 do
  import AdventOfCode2017.Day4

  def solve_puzzle,
    do: input() |> count_valid_passphrases

  def count_valid_passphrases(phrases),
    do: phrases |> Enum.filter(&is_valid_passphrase/1) |> length

  def is_valid_passphrase(passphrase) do
    words = String.split(passphrase)
    length(words) === number_of_unique(words)
  end

  def number_of_unique(list),
    do: list |> MapSet.new |> MapSet.size

end

#------------------------------------------------------------------------------
# Part Two
#
# For added security, yet another system policy has been put in place.
# Now, a valid passphrase must contain no two words that are anagrams of
# each other - that is, a passphrase is invalid if any word's letters can
# be rearranged to form any other word in the passphrase.
#
#  -  abcde fghij is a valid passphrase.
#
#  -  abcde xyz ecdab is not valid - the letters from the third word can
#     be rearranged to form the first word.
#
#  -  a ab abc abd abf abj is a valid passphrase, because all letters need
#     to be used when forming another word.
#
#  -  iiii oiii ooii oooi oooo is valid.
#
#  -  oiii ioii iioi iiio is not valid - any of these words can be
#     rearranged to form any other word.
#
# How many passphrases are valid?
#------------------------------------------------------------------------------

defmodule AdventOfCode2017.Day4.Part2 do
  import AdventOfCode2017.Day4

  def solve_puzzle,
    do: input() |> count_valid_passphrases

  def count_valid_passphrases(phrases),
    do: phrases |> Enum.filter(&is_valid_passphrase/1) |> length

  def is_valid_passphrase(passphrase) do
    sorted_words = passphrase |> String.split |> sort_each_word
    length(sorted_words) === number_of_unique(sorted_words)
  end

  def sort_each_word(words),
    do: words |> Enum.map(&sort_word/1)

  def sort_word(word),
    do: word |> String.split("") |> Enum.sort |> Enum.join

  def number_of_unique(list),
    do: list |> MapSet.new |> MapSet.size

end

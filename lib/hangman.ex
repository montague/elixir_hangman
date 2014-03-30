defmodule Hangman do
  def welcome do
    IO.puts "Welcome"
  end

  def get_letter do
    IO.getn "Pick a letter: \n"
  end

  def check_letter(letter, word, blanks) do
    # flatten the returned list of list of tuples
    # [[{idx,_}],[{idx,_}]]
    indexes =
      Regex.scan(~r/#{letter}/, word, return: :index)
      |> List.flatten
      |> Enum.map(&(elem(&1, 0)))

    if Enum.any?(indexes) do
      updated_blanks = Enum.reduce(indexes, blanks, fn(index, str) ->
        List.replace_at(String.split(str, ""), index, letter)
        |> Enum.join
      end)
      {:hit, updated_blanks}
    else
      {:miss, blanks}
    end
  end
end

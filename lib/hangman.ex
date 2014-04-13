defmodule Hangman do
  @misses_allowed 8

  def run! do
    welcome
    word = "hello"
    blanks = blanks_for word
    guess_a_letter(word, blanks, 0, [])
  end

  def welcome do
    IO.puts """
    Welcome to Hangman!
    Game on!
    """
  end

  def blanks_for(word) do
    String.replace(word, ~r/./, "_")
  end

  def format_blanks_for_print(blanks) do
    String.split(blanks,"") |> Enum.join(" ") |> String.rstrip(? )
  end

  def guess_a_letter(word, blanks, misses, letters_guessed) do
    IO.puts """
    Letters guessed: #{letters_guessed}
    Misses left: #{@misses_allowed - misses}
    #{get_status(misses)}



    #{format_blanks_for_print(blanks)}
    """
    # poor man's chomp
    guess = get_letter |> String.first
    letters_guessed = letters_guessed ++ [guess]
    { result, blanks } = check_letter(guess, word, blanks)

    cond do
      is_solved?(blanks) ->
        IO.puts """
        #{format_blanks_for_print(blanks)}
        You win!
        """
      result == :hit ->
        guess_a_letter(word, blanks, misses, letters_guessed)
      result == :miss ->
        if misses + 1 == 8 do
          IO.puts "GAME OVER"
        else
          guess_a_letter(word, blanks, misses + 1, letters_guessed)
        end
      true ->
        IO.puts "WHY AM I HERE"
    end
  end

  def get_status(misses) do
    status = "  | "
    if misses > 0, do: status = status <> "\n  0"
    if misses > 1, do: status = status <> "\n /"
    if misses > 2, do: status = status <> "|"
    if misses > 3, do: status = status <> "\\"
    if misses > 4, do: status = status <> "\n_"
    if misses > 5, do: status = status <> "/"
    if misses > 6, do: status = status <> " \\"
    if misses > 7, do: status = status <> "_"
    status
  end

  def is_solved?(blanks) do
   !(blanks =~ "_")
  end

  def get_letter do
    # grab letter and newline char
    IO.gets "Pick a letter: "
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
      { :hit, updated_blanks }
    else
      { :miss, blanks }
    end
  end
end

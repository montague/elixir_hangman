defmodule Hangman do
  @misses_allowed 8
  @words WordsRepo.load_words


  def main(args) do
    welcome
    word = hd(@words)
    misses = 0
    letters_guessed = []
    guess_a_letter(word, blanks_for(word), misses, letters_guessed)
  end

  def welcome do
    IO.puts """
    Welcome to Hangman!
    Game on!
    """
  end

  def print_status(letters_guessed, misses, blanks) do
    IO.puts """
    Letters guessed: #{letters_guessed}
    Misses left: #{@misses_allowed - misses}
    #{get_status(misses)}



    #{format_blanks_for_print(blanks)}
    """
  end

  def blanks_for(word) do
    String.replace(word, ~r/./, "_")
  end

  def format_blanks_for_print(blanks) do
    String.split(blanks,"") |> Enum.join(" ") |> String.rstrip(? )
  end

  def print_win_status(blanks) do
    IO.puts """
    #{format_blanks_for_print(blanks)}
    You win!
    """
  end

  def game_over?(@misses_allowed), do: true
  def game_over?(_), do: false

  def guess_a_letter(word, blanks, misses, letters_guessed) do
    print_status(letters_guessed, misses, blanks)

    # poor man's chomp
    guess = get_letter |> String.first

    # no-op if nothing entered
    cond do
      guess == "\n" ->
        guess_a_letter(word, blanks, misses, letters_guessed)
      Enum.any?(letters_guessed, &(&1 == guess)) ->
        guess_a_letter(word, blanks, misses, letters_guessed)
      true ->
        letters_guessed = letters_guessed ++ [guess]
        { result, blanks } = check_letter(guess, word, blanks)
        cond do
          is_solved?(blanks) ->
            print_win_status(blanks)
          result == :hit ->
            guess_a_letter(word, blanks, misses, letters_guessed)
          result == :miss ->
            misses = misses + 1
            if game_over?(misses) do
              IO.puts "GAME OVER: #{word}"
            else
              guess_a_letter(word, blanks, misses, letters_guessed)
            end
          true ->
            IO.puts "WHY AM I HERE"
        end
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

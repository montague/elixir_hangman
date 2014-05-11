defmodule Hangman do
  require EEx
  EEx.function_from_file :def, :hanging_man_status,
    "./lib/templates/hanging_man_status.eex", [:assigns]

  @misses_allowed 8

  def main(args) do
    # new game
    welcome
    WordsRepo.load_words
    |> new_game_state
    |> guess_a_letter
  end

  def welcome do
    IO.puts """
    Welcome to Hangman!
    Game on!
    """
  end

  def print_status(letters_guessed, misses, blanks) do
    IO.puts """
    Word length: #{String.length(blanks)}
    Letters guessed: #{letters_guessed}
    Misses left: #{@misses_allowed - misses}
    #{hanging_man_status(misses: misses)}



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

  def guess_a_letter(game_state) do
    word = game_state[:word]
    words = game_state[:words]
    blanks = game_state[:blanks]
    misses = game_state[:misses]
    letters_guessed = game_state[:letters_guessed]
    print_status(letters_guessed, misses, blanks)

    # poor man's chomp
    guess = get_letter |> String.first

    # no-op if nothing entered
    cond do
      guess == "\n" ->
        guess_a_letter(game_state)
      Enum.any?(letters_guessed, &(&1 == guess)) ->
        guess_a_letter(game_state)
      true ->
        letters_guessed = letters_guessed ++ [guess]
        game_state = update_game_state(game_state, [letters_guessed: letters_guessed])
        { result, blanks } = check_letter(guess, word, blanks)
        game_state = update_game_state(game_state, [blanks: blanks])
        cond do
          is_solved?(blanks) ->
            print_win_status(blanks)
            if play_again?, do: new_game_state(words) |> guess_a_letter
          result == :hit ->
            guess_a_letter(game_state)
          result == :miss ->
            misses = misses + 1
            game_state = update_game_state(game_state, [misses: misses])
            if game_over?(misses) do
              IO.puts print_status(letters_guessed, misses, blanks)
              IO.puts "GAME OVER: #{word}"
              if play_again?, do: new_game_state(words) |> guess_a_letter
            else
              guess_a_letter(game_state)
            end
          true ->
            IO.puts "BAD! NO! BAD!!"
        end
    end
  end

  def new_game_state(words) do
    [word | words] = words
    [misses: 0, letters_guessed: [],
      words: words, word: word,
      blanks: blanks_for(word)]
  end

  def update_game_state(game_state, updates) do
    updates ++ game_state
  end

  def is_solved?(blanks) do
   !(blanks =~ "_")
  end

  def get_letter do
    # grab letter and newline char
    IO.gets "Pick a letter: "
  end

  def play_again? do
    play_again = IO.gets("Play again? (y/n)\n") |> String.first
    cond do
      play_again == "y" ->
        IO.puts "Playing again!"
        true
      play_again == "n" ->
        IO.puts "Goodbye :)"
        false
      true ->
        play_again?
    end
  end

  def check_letter(letter, word, blanks) do
    # flatten the returned list of list of tuples
    # [[{idx,_}],[{idx,_}]]
    # and grab only the indexes where the letter occurred.
    indexes =
      Regex.scan(~r/#{letter}/, word, return: :index)
      |> List.flatten
      |> Enum.map(&(elem(&1, 0)))

    if Enum.any?(indexes) do
      updated_blanks = Enum.reduce(indexes, blanks, fn(index, acc_str) ->
        String.split(acc_str, "") |> List.replace_at(index, letter) |> Enum.join
      end)
      { :hit, updated_blanks }
    else
      { :miss, blanks }
    end
  end
end

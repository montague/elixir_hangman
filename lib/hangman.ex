defmodule Hangman do

  def run! do
    welcome
    word = "hello"
    blanks = blanks_for word
    guess_a_letter(word, blanks)
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

  # get letter, check for win
  # if no win, update board and print out, call again
  # else, print out win, call "run"
  #def game_loop({ :win }, word, blanks) do
    #IO.puts "YOU WIN!\n"
  #end

  def guess_a_letter(word, blanks) do
    IO.puts """
    current status:
    #{blanks}
    """
    # poor man's chomp
    guess = get_letter |> String.rstrip(?\n)
    { _, blanks } = check_letter(guess, word, blanks)
    if is_solved?(blanks) do
      { :win }
    else
      guess_a_letter(word, blanks)
    end
  end

  def is_solved?(blanks) do
   !(blanks =~ "_")
  end

  def get_letter do
    # grab letter and newline char
    IO.getn "Pick a letter: \n", 2
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

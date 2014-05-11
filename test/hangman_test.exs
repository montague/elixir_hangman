defmodule HangmanTest do
  use ExUnit.Case, async: true
  import ExUnit.CaptureIO

  # return from this callback must be
  # {:ok, data} where data is a keyword list
  # of stuff to reference in the tests
  setup_all do
    { :ok, word: "hello", blanks: "_e__o" }
  end

  #  |
  #  0
  # /|\
  #_/ \_
  test ".check_letter hit", meta do
    assert Hangman.check_letter("l", meta[:word], meta[:blanks]) == {:hit, "_ello"}
  end

  test ".check_letter miss", meta do
    assert Hangman.check_letter("x", meta[:word], meta[:blanks]) == {:miss, meta[:blanks]}
  end

  test ".is_solved? true", meta do
    assert Hangman.is_solved?(meta[:word])
  end

  test ".is_solved? false", meta do
    refute Hangman.is_solved?(meta[:blanks])
  end

  test ".blanks_for", meta do
    assert Hangman.blanks_for(meta[:word]) == "_____"
  end

  test ".game_over? true" do
    assert Hangman.game_over?(8)
  end

  test ".game_over? false" do
    refute Hangman.game_over?(1)
  end

  test ".print_status", meta do
    assert capture_io(fn -> 
      Hangman.print_status("abc", 1, "__x")
    end) == """
    Word length: 3
    Letters guessed: abc
    Misses left: 7
      | 
      0



    _ _ x

    """
  end

  #test ".guess_a_letter hit", meta do
    #capture_io("l", fn ->
      #assert Hangman.guess_a_letter(meta[:word], meta[:blanks]) == { :hit }
    #end)
  #end

  #test ".guess_a_letter win", meta do
    #[guess | tail] = String.split(meta[:word],"")
    #blanks = "_" <> Enum.join(tail)
    #capture_io(guess, fn ->
      #assert Hangman.guess_a_letter(meta[:word], blanks) == { :win }
    #end)
  #end

  #test ".guess_a_letter miss", meta do
    #capture_io("x", fn ->
      #assert Hangman.guess_a_letter(meta[:word], meta[:blanks]) == { :miss }
    #end)
  #end
end

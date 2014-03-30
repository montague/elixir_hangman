defmodule HangmanTest do
  use ExUnit.Case, async: true

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
end

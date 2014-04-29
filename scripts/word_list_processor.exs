defmodule WordListProcessor do
  # from http://joearms.github.io/2013/05/31/a-week-with-elixir.html
  def pp(x) do 
  :io_lib.format("~p", [x])
  |> :lists.flatten
  |> :erlang.list_to_binary
  end

  def read_words(file_path) do
    File.read!(file_path)
    |> String.split("\r\n")
    |> Enum.filter(fn(word) -> String.length(word) > 5 end)
  end

  def write_words_list(words, file_path) do
    f = File.open!(file_path, [:write])
    Enum.each(words, &IO.puts(f, &1))
  end
end

WordListProcessor.read_words("./data/raw_word_list.txt")
|> WordListProcessor.write_words_list("./data/valid_words_list.txt")

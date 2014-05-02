defmodule WordsRepo do
  # given an IO stream,
  # separate words by \n,
  # filter out words shorter than
  # 5
  def load_words do
    :random.seed(:erlang.now)
    list = File.read!("./data/valid_words_list.txt")
    |> String.split("\n")
    Enum.slice(list, 0, length(list) - 1)
    |> Enum.shuffle
  end

  # from http://joearms.github.io/2013/05/31/a-week-with-elixir.html
  def pp(x) do 
  :io_lib.format("~p", [x])
  |> :lists.flatten
  |> :erlang.list_to_binary
  end
end

Code.load_file("./deps/benchmark/lib/benchmark.ex")
#Code.load_file("./deps/benchmark/lib/omg.ex")

defmodule X do
  require Benchmark
  # from http://joearms.github.io/2013/05/31/a-week-with-elixir.html
  def pp(x) do 
    :io_lib.format("~p", [x])
    |> :lists.flatten
    |> :erlang.list_to_binary
  end

  def bm do
    Benchmark.times 1000, do: 2 * 4
  end
end

X.bm

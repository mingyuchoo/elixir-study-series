defmodule Example do
  def double(x) do
    :timer.sleep(3000)
    x * 2
  end

  def run do
    task = Task.async(Example, :double, [2000])

    for i <- 1..10 do
      IO.puts("I'm working...#{i}")
      :timer.sleep(1000)
    end

    Task.await(task) |> IO.puts()
  end
end

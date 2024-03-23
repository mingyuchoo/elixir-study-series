defmodule Adding do
  def plus_one(number) do
    number + 1
  end

  def plus_two(number), do: number + 2
end

IO.puts(IO.inspect(Enum.map([1, 2, 3], fn number -> Adding.plus_one(number) end)))
IO.puts(IO.inspect(Enum.map([1, 2, 3], &Adding.plus_one(&1))))
IO.puts(IO.inspect(Enum.map([1, 2, 3], &Adding.plus_one/1)))

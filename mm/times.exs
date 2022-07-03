defmodule Times1 do
  def double1(n) do
    n * 2
  end
  def double2(n), do: n * 2
  def greet(greeting, name), do: (
    IO.puts greeting
    IO.puts "How're you doing, #{name}?"
  )
end

defmodule Times2, do: (def double1(n), do: n * 2)

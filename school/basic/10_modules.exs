defmodule Example do
  def greeting(name) do
    "Hello #{name}."
  end

  @hi "Hi"

  def hi(name) do
    ~s(#{@hi} #{name}.)
  end
end

Example.greeting("Sean") |> IO.inspect()
Example.hi("Smith") |> IO.inspect()

defmodule Example.Greetings do
  def morning(name) do
    "Good morning #{name}."
  end

  def evening(name) do
    "Good night #{name}."
  end
end

Example.Greetings.morning("Sean") |> IO.inspect()

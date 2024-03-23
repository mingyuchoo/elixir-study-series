defmodule Sayings.Greetings do
  def basic(name), do: "Hi, #{name}"
end

defmodule Example1 do
  def greeting(name), do: Sayings.Greetings.basic(name)
end

defmodule Example2 do
  # can use `Sayings.Greetings` to `Greetings`
  alias Sayings.Greetings
  def greeting(name), do: Greetings.basic(name)
end

defmodule Example3 do
  alias Sayings.Greetings, as: Hi
  def print_message(name), do: Hi.basic(name)
end

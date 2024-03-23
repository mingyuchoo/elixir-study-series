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

import List, only: [last: 1]
last([1, 2, 3]) |> IO.inspect()

defmodule Example4 do
  # require
  require Sayings.Greetings
  # alias
  alias Sayings.Greetings, as: Hi

  def hi(name) do
    Hi.basic(name)
  end
end

Example4.hi("Adam" |> IO.inspect())

defmodule Hello do
  defmacro __using__(opts) do
    say = Keyword.get(opts, :greeting, "Hi")

    quote do
      def hello(name), do: unquote(say) <> ", " <> name
    end
  end
end

defmodule Example5 do
  use Hello, greeting: "Hola"
end

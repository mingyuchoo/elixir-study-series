defmodule Sayings.Greetings do
  @moduledoc """
  """
  def basic(name), do: "Hi, #{name}"
end

defmodule Example1 do
  @moduledoc """
  """
  def greeting(name), do: Sayings.Greetings.basic(name)
end

defmodule Example2 do
  @moduledoc """
  """
  # can use `Sayings.Greetings` to `Greetings`
  alias Sayings.Greetings
  def greeting(name), do: Greetings.basic(name)
end

defmodule Example3 do
  @moduledoc """
  """
  alias Sayings.Greetings, as: Hi
  def print_message(name), do: Hi.basic(name)
end

import List, only: [last: 1]
last([1, 2, 3]) |> IO.inspect()

defmodule Example4 do
  @moduledoc """
  """
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
  @moduledoc """
  매크로
  """
  defmacro __using__(opts) do
    say = Keyword.get(opts, :greeting, "Hi")

    quote do
      def hello(name), do: unquote(say) <> ", " <> name
    end
  end
end

defmodule Example5 do
  @moduledoc """
  모듈 `Hello`에 있는 매크로에 직접 접근하려 `use`를 이용합니다.

  ## Examples

      iex> Example5.hello("Sean")
      "Hola, Sean

  """
  use Hello, greeting: "Hola"
end

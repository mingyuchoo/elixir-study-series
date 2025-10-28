handle_result = fn
  {:ok, result} -> IO.puts("Handle result...")
  {:ok, _} -> IO.puts("This would be never run as previous will be matched beforehand.")
  {:error} -> IO.puts("An error has occurred!")
end

some_result = 1
handle_result.({:ok, some_result})
# Handle result...

handle_result.({:error})
# An error has occurred!

defmodule Functions do
  defmodule Greeter do
    def hello, do: "Hello, anonymous person!"

    def hello(%{name: person_name}) do
      "Hello, " <> person_name
    end

    def hello2(%{name: person_name} = person) do
      IO.inspect(person)
      "Hello, " <> person_name
    end

    def hello(name, language_code \\ "en") do
      phrase(language_code) <> name
    end

    defp phrase("en"), do: "Hello, "
    defp phrase("es"), do: "Hola, "

    def hi(name), do: "Hi, " <> name
  end

  defmodule Length do
    def of([]), do: 0
    def of([_ | tail]), do: 1 + of(tail)
  end
end

IO.puts(Functions.Greeter.hello())
IO.puts(Functions.Greeter.hello(%{name: "Choo", age: "20", favorite_color: "Red"}))
IO.puts(Functions.Greeter.hello2(%{name: "Choo", age: "20", favorite_color: "Red"}))

IO.puts(Functions.Greeter.hello("Jimmy", "en"))
IO.puts(Functions.Greeter.hello("Alonzo", "es"))

IO.puts(Functions.Greeter.hi("Monet"))
IO.puts(Functions.Length.of([]))
IO.puts(Functions.Length.of([1, 2, 3]))

defmodule Guards do
  def hello(names, language_code \\ "en")

  def hello(names, language_code) when is_list(names) do
    Enum.join(names, ", ") |> hello(language_code)
  end

  def hello(name, language_code) when is_binary(name) do
    phrase(language_code) <> name
  end

  defp phrase("en"), do: "Hello, "
  defp phrase("es"), do: "Hola, "
end

IO.puts(Guards.hello(["Sean", "Steve"]))

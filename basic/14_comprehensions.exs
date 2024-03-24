defmodule Comprehensions do
  @doc """
  list
  """
  def get_list() do
    list = [1, 2, 3, 4, 5]
    for x <- list, do: x * x
  end

  @doc """
  keyword list
  """
  def get_key_value do
    for {_key, value} <- [one: 1, two: 2, three: 3], do: value
  end

  @doc """
  map
  """
  def get_map do
    for {key, value} <- %{"a" => "A", "b" => "B"}, do: {key, value}
  end

  @doc """
  binary
  """
  def get_binary do
    for <<c <- "hello">>, do: <<c>>
  end

  @doc """
  pattern matched keyword list
  """
  def get_pattern_matched_keyword_list do
    for {:ok, value} <- [ok: "Hello", error: "Unknown", ok: "World"], do: value
  end

  @doc """
  nested generator
  """
  def get_nested_generator do
    list = [1, 2, 3, 4, 5]

    for n <- list, times <- 1..n, do: String.duplicate("*", times)
  end

  @doc """
  even and remain
  """
  def get_even_and_remain do
    import Integer
    for x <- 1..100, is_even(x), rem(x, 3) == 0, do: x
  end

  @doc """
  list into other
  """
  def get_map_from_keyword_list do
    for {key, value} <- [one: 1, two: 2, three: 3], into: %{}, do: {key, value}
  end
end

Comprehensions.get_list() |> IO.inspect()
Comprehensions.get_key_value() |> IO.inspect()
Comprehensions.get_map() |> IO.inspect()
Comprehensions.get_binary() |> IO.inspect()
Comprehensions.get_pattern_matched_keyword_list() |> IO.inspect()
Comprehensions.get_nested_generator() |> IO.inspect()
Comprehensions.get_even_and_remain() |> IO.inspect()
Comprehensions.get_map_from_keyword_list() |> IO.inspect()

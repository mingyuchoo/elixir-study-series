defmodule Strings do
  @moduledoc """
  Strings for Basic
  """

  @doc """
  get_string_from_binary
  """
  def get_string_from_binary do
    string = <<104, 101, 108, 108, 111>>
    string <> <<0>>
  end

  @doc """
  """
  def get_length do
    String.length("Hello")
  end

  @doc """
  """
  def get_replace do
    String.replace("Hello", "e", "a")
  end

  @doc """
  """
  def get_duplicate do
    String.duplicate("Oh my ", 3)
  end

  @doc """
  """
  def get_split do
    String.split("Hello World", " ")
  end
end

Strings.get_string_from_binary() |> IO.inspect()
Strings.get_length() |> IO.inspect()
Strings.get_replace() |> IO.inspect()
Strings.get_duplicate() |> IO.inspect()
Strings.get_split() |> IO.inspect()

defmodule Anagram do
  @moduledoc """
  """

  @doc """
  """
  def anagrams?(a, b) when is_binary(a) and is_binary(b) do
    sort_string(a) == sort_string(b)
  end

  defp sort_string(string) do
    string
    |> String.downcase()
    |> String.graphemes()
    |> Enum.sort()
  end
end

Anagram.anagrams?("Hello", "ohell") |> IO.inspect()
Anagram.anagrams?("María", "íMara") |> IO.inspect()

defmodule Example do
  @moduledoc """
  iex> c "filename.exs"
  """

  @doc """
  ## Examples
      iex> Example.add(2, 3)
      5
      :ok
      iex> spawn(Example, :add, [2, 3])
      5
  """
  def add(a, b) do
    IO.puts(a + b)
  end

  @doc """
  ## Examples
      iex> spawn(Example, :double, [100])
      10000
  """
  def double(x) do
    :timer.sleep(3000)
    IO.puts(x * 2)
  end
end

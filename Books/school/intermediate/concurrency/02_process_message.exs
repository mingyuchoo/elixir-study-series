defmodule Example do
  @moduledoc """
  Sending message to process
  ## Examples
      iex> c "filename.exs"
  """

  @doc """
  ## Examples
      iex> pid = spawn(Example, :work, [])
      iex> send pid, {:ok, "hello"}
      Hi, there.
      {:ok, "hello"}
  """
  def work() do
    receive do
      {:ok, "hello"} -> IO.puts("Hi, there.")
    end

    work()
  end
end

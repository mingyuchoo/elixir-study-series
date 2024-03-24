defmodule ThrowCatches do
  @moduledoc """
  """

  @doc """
  """
  def get_throw_catch do
    try do
      for x <- 0..10 do
        if x == 5, do: throw(x)
        IO.puts(x)
      end
    catch
      x -> "Caught: #{x}"
    end
  end
end

ThrowCatches.get_throw_catch() |> IO.inspect()

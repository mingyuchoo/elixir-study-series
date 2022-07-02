defmodule MyList do
  def reduce([], value, _func), do: value
  def reduce([ head | tail ], value, func), do: reduce(tail, func.(head, value), func)

  @doc """
  -- in haskell

  module MyList where
  reduce' :: [a] -> b -> (a -> b -> b) -> b
  reduce' [] v f     = v
  reduce' (x:xs) v f = reduce' xs (f x v) f
  """
end

IO.puts MyList.reduce [1,2,3,4,5], 0, fn (x, y) -> x + y end
IO.puts MyList.reduce([1,2,3,4,5], 1, &(&1 * &2))

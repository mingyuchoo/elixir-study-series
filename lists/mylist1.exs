defmodule MyList do

  def len([]), do: 0
  def len([ _head | tail ]), do: 1 + len(tail)

  @doc """
  -- in haskell
  len :: [Int] -> Int
  len []      = 0
  len (_:xs) = 1 + len xs
  """

  def add_1([]), do: []
  def add_1([ head | tail ]), do: [ head+1 | add_1(tail) ]

  @doc """
  -- in haskell
  add_1 :: [Int] -> [Int]
  add_1 [] = []
  add_1 (x:xs) =  x+1 : add_1 xs
  """

  def map([], _func), do: []
  def map([ head | tail ], func), do: [ func.(head) | map(tail, func) ]

  @doc """
  -- in haskell
  map' :: [a] -> (a -> b) -> [b]
  map' [] f     = []
  map' (x:xs) f = f x : map' xs f
  """
end

IO.puts MyList.len([11,12,13,14,15])
IO.inspect MyList.map [1,2,3,4], fn (x) -> x*x end
IO.inspect MyList.map [1,2,3,4], fn (x) -> x*1 end
IO.inspect MyList.map [1,2,3,4], fn (x) -> x>2 end

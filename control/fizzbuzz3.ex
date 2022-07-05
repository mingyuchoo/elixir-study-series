defmodule FizzBuzz do
  def upto(n) when n > 0, do: 1..n |> Enum.map(&fizzbuzz/1)

  defp fizzbuzz(n), do: _fizzbuzz(n, rem(n, 3), rem(n, 5))

  defp _fizzbuzz(_, 0, 0), do: "FizzBuzz"
  defp _fizzbuzz(_, 0, _), do: "Fizz"
  defp _fizzbuzz(_, _, 0), do: "Buzz"
  defp _fizzbuzz(n, _, _), do: n
end

"""
-- | in Haskell

module FizzBuzz
    where

upto :: IO ()
upto = print $ map fizzBuzz1 [1..20]

fizzBuzz1 :: Int -> String
fizzBuzz1 n =
  case (n, n `mod` 3, n `mod` 5) of
    (_, 0, 0) -> "FizzBuzz"
    (_, 0, _) -> "Fizz"
    (_, _, 0) -> "Buzz"
    _         -> show n

fizzBuzz2 :: Int -> String
fizzBuzz2 n | n `mod` 15 == 0 = "FizzBuzz"
            | n `mod`  5 == 0 = "Fizz"
            | n `mod`  3 == 0 = "Buzz"
            | otherwise       = show n
"""

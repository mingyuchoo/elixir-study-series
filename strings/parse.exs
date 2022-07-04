defmodule Parse do
  def number([?- | tail]), do: _number_digits(tail, 0) * -1
  def number([?+ | tail]), do: _number_digits(tail, 0)
  def number(str), do: _number_digits(str, 0)

  defp _number_digits([], value), do: value

  defp _number_digits([digit | tail], value) when digit in '0123456789',
    do: _number_digits(tail, value * 10 + digit - ?0)

  defp _number_digits([non_digit | _], _), do: raise("Invalid digit '#{[non_digit]}'")

  @doc """
  -- in Haskell

  import           Data.Char (digitToInt)

  number :: [Char] -> Int
  number ('-':xs) = numberDigits xs  (0  * (-1))
  number ('+':xs) = numberDigits xs  0
  number xs       = numberDigits xs  0

  numberDigits :: [Char] -> Int -> Int
  numberDigits [] v = v
  numberDigits (x:xs) v | x `elem` "0123456789" = numberDigits xs (v*10 + checkZero x)
  numberDigits (x:_) _ = error $ "Invalid digit " ++ show x

  checkZero :: Char -> Int
  checkZero d = if d == '0' then 0 else digitToInt d
  """
end

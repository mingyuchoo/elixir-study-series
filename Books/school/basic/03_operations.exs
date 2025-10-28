IO.puts "Arithmetic -----------------------"

# div/2 -> div(integer(), neg_integer() | pos_integer()) :: integer()

Enum.each([{2, 2}],
  fn (x) -> IO.puts "#{x}" end)

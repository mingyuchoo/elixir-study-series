# sigil ~c
~c/2 + 7 = #{2 + 7}/ |> IO.inspect()

# sigil ~C
~C/2 + 7 = #{2 + 7}/ |> IO.inspect()

# sigil ~r
re = ~r/elixir/

"Elixir" =~ re
# false

"elixir" =~ re
# true

# sigil ~r for ignore case
re = ~r/elixir/i

"Elixir" =~ re
# true

"elixir" =~ re
# true

string = "100_000_000"
Regex.split(~r/_/, string) |> IO.inspect()

# sigil ~s
~s/welcome to elixir #{String.downcase("SCHOOL")}/ |> IO.puts()

# sigil ~S
~S/wlecome to elixir #{String.downcase "SCHOOL"}/ |> IO.puts()

# sigil ~w
~w/i love #{~c"e"}lixir school/ |> IO.inspect()

# sigil ~W
~W/i love #{'e'}lixir school/ |> IO.inspect()

defmodule MySigils do
  def sigil_x(string, []), do: String.upcase(string)
end

# ~x/Jose drank Elixir/
